namespace DefaultPublisher.DT.TableExt;
using Microsoft.Inventory.Intrastat;

tableextension 50789 AreaTableExt extends "Area With Ext"
{
    fields
    {
        field(50789; "DT Unit Volume"; Decimal)
        {
            Caption = 'DT Unit Volume';
            DecimalPlaces = 0 : 5;
        }
        field(50790; "A stupid Media"; Media)
        {
            Caption = 'A stupid Media';
        }
        field(50791; "And a stupid MediaSet"; MediaSet)
        {
            Caption = 'And a stupid MediaSet';
        }

    }   
}
