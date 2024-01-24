namespace DefaultPublisher.DT.TableExt;
using Microsoft.Sales.Document;

tableextension 50791 DTSLTableExtWitSubs extends "DT SL With Ext and Subs"
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
