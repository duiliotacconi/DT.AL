namespace DefaultPublisher.MakeBase64Faster;

using System.Text;
using System.IO;
using System.Utilities;

codeunit 50101 "Base64 File Mgt."
{
    /// <summary>
    /// Uploads a zip archive containing files, encodes each file to Base64
    /// using the new stream-based overload and stores the result in the database.
    /// Only the pure ToBase64 call is timed for each file.
    /// </summary>
    procedure UploadZipAndEncode(): Integer
    var
        DataCompression: Codeunit "Data Compression";
        ZipTempBlob: Codeunit "Temp Blob";
        ZipInStr: InStream;
        ZipOutStr: OutStream;
        EntryList: List of [Text];
        EntryName: Text;
        ClientFileName: Text;
        UploadedCount: Integer;
    begin
        if not UploadIntoStream('Select a zip file with files', '', 'Zip files (*.zip)|*.zip', ClientFileName, ZipInStr) then
            exit(0);

        // Buffer the uploaded stream so it can be read reliably by Data Compression.
        ZipTempBlob.CreateOutStream(ZipOutStr);
        CopyStream(ZipOutStr, ZipInStr);

        DataCompression.OpenZipArchive(ZipTempBlob, false);
        DataCompression.GetEntryList(EntryList);

        foreach EntryName in EntryList do
            if EncodeAndStoreEntry(DataCompression, EntryName) then
                UploadedCount += 1;

        DataCompression.CloseZipArchive();
        exit(UploadedCount);
    end;

    local procedure EncodeAndStoreEntry(var DataCompression: Codeunit "Data Compression"; EntryName: Text): Boolean
    var
        Base64Convert: Codeunit "Base64 Convert";
        FileTempBlob: Codeunit "Temp Blob";
        Base64TempBlob: Codeunit "Temp Blob";
        Base64File: Record "Base64 File";
        Setup: Record "Base64 File Setup";
        FileInStr: InStream;
        Base64OutStr: OutStream;
        Base64InStr: InStream;
        DbOutStr: OutStream;
        Base64Text: Text;
        StartTime: DateTime;
        EncodeDur: Duration;
        EntryLength: Integer;
        Base64Len: Integer;
    begin
        Setup.GetSetup();

        // Extract the file from the archive into memory (not timed).
        EntryLength := DataCompression.ExtractEntry(EntryName, FileTempBlob);
        if EntryLength = 0 then
            exit(false);

        FileTempBlob.CreateInStream(FileInStr);
        Base64TempBlob.CreateOutStream(Base64OutStr, TextEncoding::UTF8);

        case Setup."Encode Method" of
            Setup."Encode Method"::"Text-based":
                begin
                    // --- Timed section: encode only ---
                    StartTime := CurrentDateTime();
                    //Base64Text := Base64Convert.ToBase64(FileInStr);
                    Base64OutStr.WriteText(Base64Convert.ToBase64(FileInStr));
                    EncodeDur := CurrentDateTime() - StartTime;
                    // --- End timed section ---
                    //Base64OutStr.WriteText(Base64Text);
                    Base64Len := StrLen(Base64Text);
                end;
            Setup."Encode Method"::"Stream-based (new)":
                begin
                    // --- Timed section: encode only ---
                    StartTime := CurrentDateTime();
                    Base64Convert.ToBase64(FileInStr, false, Base64OutStr); //To Be commented in 27.x or earlier
                    EncodeDur := CurrentDateTime() - StartTime;
                    // --- End timed section ---
                    Base64Len := Base64TempBlob.Length();
                end;
        end;

        // Persist the Base64 content in the database (not timed).
        Base64File.Init();
        Base64File."File Name" := CopyStr(EntryName, 1, MaxStrLen(Base64File."File Name"));
        Base64File."Original Size (Bytes)" := EntryLength;
        Base64File."Base64 Length" := Base64Len;
        Base64File."Encode Time (ms)" := EncodeDur;
        Base64File."Encode Method" := Setup."Encode Method";

        Base64TempBlob.CreateInStream(Base64InStr, TextEncoding::UTF8);
        Base64File."Base64 Data".CreateOutStream(DbOutStr, TextEncoding::UTF8);
        CopyStream(DbOutStr, Base64InStr);

        Base64File.Insert(true);
        exit(true);
    end;

    /// <summary>
    /// Reads every stored Base64 file back from the database and decodes it
    /// using the stream-based FromBase64 overload. Only the FromBase64 call is timed.
    /// </summary>
    procedure DecodeAll(): Integer
    var
        Base64File: Record "Base64 File";
        DecodedCount: Integer;
    begin
        if Base64File.FindSet(true) then
            repeat
                DecodeFile(Base64File);
                DecodedCount += 1;
            until Base64File.Next() = 0;
        exit(DecodedCount);
    end;

    local procedure DecodeFile(var Base64File: Record "Base64 File")
    var
        DecodedTempBlob: Codeunit "Temp Blob";
    begin
        DecodeFileToBlob(Base64File, DecodedTempBlob);
    end;

    /// <summary>
    /// Decodes every stored file from Base64 and rebuilds a zip archive from them,
    /// then offers the zip for download. Only the FromBase64 call is timed for each
    /// file; extraction from the database and adding entries to the zip are excluded.
    /// </summary>
    procedure DecodeAllAndCreateZip(): Integer
    var
        DataCompression: Codeunit "Data Compression";
        DecodedTempBlob: Codeunit "Temp Blob";
        ZipTempBlob: Codeunit "Temp Blob";
        Base64File: Record "Base64 File";
        DecodedInStr: InStream;
        ZipInStr: InStream;
        ZipOutStr: OutStream;
        ZipFileName: Text;
        DecodedCount: Integer;
    begin
        if Base64File.IsEmpty() then
            exit(0);

        DataCompression.CreateZipArchive();

        Base64File.FindSet(true);
        repeat
            Clear(DecodedTempBlob);
            // Timed decode happens inside DecodeFileToBlob (only the FromBase64 call).
            DecodeFileToBlob(Base64File, DecodedTempBlob);

            // Not timed: add the decoded file to the zip archive.
            DecodedTempBlob.CreateInStream(DecodedInStr);
            DataCompression.AddEntry(DecodedInStr, Base64File."File Name");
            DecodedCount += 1;
        until Base64File.Next() = 0;

        DataCompression.SaveZipArchive(ZipTempBlob);
        DataCompression.CloseZipArchive();

        ZipTempBlob.CreateInStream(ZipInStr);
        ZipFileName := 'DecodedFiles.zip';
        DownloadFromStream(ZipInStr, 'Download decoded files', '', 'Zip files (*.zip)|*.zip', ZipFileName);

        exit(DecodedCount);
    end;

    local procedure DecodeFileToBlob(var Base64File: Record "Base64 File"; var DecodedTempBlob: Codeunit "Temp Blob")
    var
        Base64Convert: Codeunit "Base64 Convert";
        Setup: Record "Base64 File Setup";
        Base64InStr: InStream;
        DecodedOutStr: OutStream;
        Base64Text: Text;
        DecodedText: Text;
        Line: Text;
        StartTime: DateTime;
        DecodeDur: Duration;
    begin
        Setup.GetSetup();

        Base64File.CalcFields("Base64 Data");
        if not Base64File."Base64 Data".HasValue() then
            exit;

        Base64File."Base64 Data".CreateInStream(Base64InStr, TextEncoding::UTF8);
        while not Base64InStr.EOS() do begin
            Base64InStr.ReadText(Line);
            Base64Text += Line;
        end;

        DecodedTempBlob.CreateOutStream(DecodedOutStr);

        case Setup."Decode Method" of
            Setup."Decode Method"::"Text-based":
                begin
                    // --- Timed section: decode and write into OutStr ---
                    StartTime := CurrentDateTime();
                    //DecodedText := Base64Convert.FromBase64(Base64Text);
                    DecodedOutStr.WriteText(Base64Convert.FromBase64(Base64Text));
                    DecodeDur := CurrentDateTime() - StartTime;
                    // --- End timed section ---
                    //DecodedOutStr.WriteText(DecodedText);
                end;
            Setup."Decode Method"::"Stream-based (new)":
                begin
                    // --- Timed section: decode into OutStr ---
                    StartTime := CurrentDateTime();
                    Base64Convert.FromBase64(Base64Text, DecodedOutStr); //To Be commented in 27.x or earlier
                    DecodeDur := CurrentDateTime() - StartTime;
                    // --- End timed section ---
                end;
        end;

        Base64File."Decode Time (ms)" := DecodeDur;
        Base64File."Decode Method" := Setup."Decode Method";
        Base64File.Modify(true);
    end;

}
