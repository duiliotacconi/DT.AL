namespace DefaultPublisher.DT.TableExt;
using Microsoft.Sales.Document;

tableextension 50790 DTSLTableExt extends "DT Sales Line With Ext"
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
    }   
}
