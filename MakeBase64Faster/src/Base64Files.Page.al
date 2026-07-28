namespace DefaultPublisher.MakeBase64Faster;

page 50101 "Base64 Files"
{
    Caption = 'Base64 Files';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Base64 File";
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            group(Totals)
            {
                Caption = 'Totals';

                field(NoOfFiles; NoOfFiles)
                {
                    Caption = 'Number of files';
                    ToolTip = 'Specifies how many files are currently stored.';
                    Editable = false;
                }
                field(TotalEncodeMs; TotalEncodeMs)
                {
                    Caption = 'Total encode time (ms)';
                    ToolTip = 'Specifies the sum of the encode times of all files.';
                    DecimalPlaces = 0 : 3;
                    Editable = false;
                }
                field(TotalDecodeMs; TotalDecodeMs)
                {
                    Caption = 'Total decode time (ms)';
                    ToolTip = 'Specifies the sum of the decode times of all files.';
                    DecimalPlaces = 0 : 3;
                    Editable = false;
                }
                field(AvgEncodeMs; AvgEncodeMs)
                {
                    Caption = 'Average encode time (ms)';
                    ToolTip = 'Specifies the total encode time divided by the number of files.';
                    DecimalPlaces = 0 : 3;
                    Editable = false;
                }
                field(AvgDecodeMs; AvgDecodeMs)
                {
                    Caption = 'Average decode time (ms)';
                    ToolTip = 'Specifies the total decode time divided by the number of files.';
                    DecimalPlaces = 0 : 3;
                    Editable = false;
                }
            }
            repeater(Files)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the entry number of the file.';
                }
                field("File Name"; Rec."File Name")
                {
                    ToolTip = 'Specifies the name of the file inside the zip archive.';
                }
                field("Original Size (Bytes)"; Rec."Original Size (Bytes)")
                {
                    ToolTip = 'Specifies the uncompressed size of the file in bytes.';
                }
                field("Base64 Length"; Rec."Base64 Length")
                {
                    ToolTip = 'Specifies the length of the Base64 representation.';
                }
                field("Encode Time (ms)"; Rec."Encode Time (ms)")
                {
                    ToolTip = 'Specifies the time it took to encode this file to Base64.';
                }
                field("Encode Method"; Rec."Encode Method")
                {
                    ToolTip = 'Specifies which method was used to encode this file.';
                }
                field("Decode Time (ms)"; Rec."Decode Time (ms)")
                {
                    ToolTip = 'Specifies the time it took to decode this file from Base64.';
                }
                field("Decode Method"; Rec."Decode Method")
                {
                    ToolTip = 'Specifies which method was used to decode this file.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UploadZip)
            {
                Caption = 'Upload zip and encode';
                ToolTip = 'Uploads a zip archive with files, encodes each file to Base64 and stores it in the database, measuring the encode time per file.';
                Image = Import;
                trigger OnAction()
                var
                    FileMgt: Codeunit "Base64 File Mgt.";
                    Uploaded: Integer;
                    StartDateTime: Datetime;
                begin
                    StartDateTime := CurrentDateTime;
                    Uploaded := FileMgt.UploadZipAndEncode();
                    Message('Uploaded and Encoded duration: %1', Format(CurrentDateTime - StartDateTime));
                    UpdateTotals();
                    CurrPage.Update(false);
                    if Uploaded > 0 then
                        Message('%1 file(s) encoded and stored.', Uploaded)
                    else
                        Message('No files were imported.');
                end;
            }
            action(DecodeFiles)
            {
                Caption = 'Decode files';
                ToolTip = 'Decodes every stored file from Base64, measuring the decode time per file.';
                Image = Export;
                trigger OnAction()
                var
                    FileMgt: Codeunit "Base64 File Mgt.";
                    Decoded: Integer;
                begin
                    Decoded := FileMgt.DecodeAll();
                    UpdateTotals();
                    CurrPage.Update(false);
                    Message('%1 file(s) decoded.', Decoded);
                end;
            }
            action(DecodeToZip)
            {
                Caption = 'Decode and export zip';
                ToolTip = 'Decodes every stored file from Base64, measuring only the decode time, rebuilds a zip archive and downloads it.';
                Image = ExportFile;
                trigger OnAction()
                var
                    FileMgt: Codeunit "Base64 File Mgt.";
                    Decoded: Integer;
                    StartDateTime: Datetime;
                begin
                    StartDateTime := CurrentDateTime;
                    Decoded := FileMgt.DecodeAllAndCreateZip();
                    Message('Uploaded and Encoded duration: %1', Format(CurrentDateTime - StartDateTime));
                    UpdateTotals();
                    CurrPage.Update(false);
                    if Decoded > 0 then
                        Message('%1 file(s) decoded and exported to zip.', Decoded)
                    else
                        Message('No files to decode.');
                end;
            }
            action(OpenSetup)
            {
                Caption = 'Setup';
                ToolTip = 'Opens the setup where you choose the encode and decode method (legacy text-based or new stream-based).';
                Image = Setup;
                RunObject = page "Base64 File Setup";
            }
            action(ClearAll)
            {
                Caption = 'Clear all';
                ToolTip = 'Deletes all stored files so you can run a new test.';
                Image = Delete;
                trigger OnAction()
                begin
                    if not Confirm('Delete all stored files?', false) then
                        exit;
                    Rec.DeleteAll();
                    UpdateTotals();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(UploadZip_Promoted; UploadZip) { }
                actionref(DecodeFiles_Promoted; DecodeFiles) { }
                actionref(DecodeToZip_Promoted; DecodeToZip) { }
                actionref(OpenSetup_Promoted; OpenSetup) { }
                actionref(ClearAll_Promoted; ClearAll) { }
            }
        }
    }

    var
        NoOfFiles: Integer;
        TotalEncodeMs: Decimal;
        TotalDecodeMs: Decimal;
        AvgEncodeMs: Decimal;
        AvgDecodeMs: Decimal;

    trigger OnOpenPage()
    begin
        UpdateTotals();
    end;

    local procedure UpdateTotals()
    var
        Base64File: Record "Base64 File";
    begin
        NoOfFiles := 0;
        TotalEncodeMs := 0;
        TotalDecodeMs := 0;
        AvgEncodeMs := 0;
        AvgDecodeMs := 0;
        if Base64File.FindSet() then
            repeat
                NoOfFiles += 1;
                TotalEncodeMs += Base64File."Encode Time (ms)";
                TotalDecodeMs += Base64File."Decode Time (ms)";
            until Base64File.Next() = 0;
        if NoOfFiles > 0 then begin
            AvgEncodeMs := TotalEncodeMs / NoOfFiles;
            AvgDecodeMs := TotalDecodeMs / NoOfFiles;
        end;
    end;
}
