enum 50131 ReadIsolationLevelType
{
    Extensible = true;
    value(0; Default)
    {
        Caption = 'Default';
    }
    value(1; ReadUncommitted)
    {
        Caption = 'ReadUncommitted';
    }
    value(2; ReadCommitted)
    {
        Caption = 'ReadCommitted';
    }
    value(3; RepeatableRead)
    {
        Caption = 'RepeatableRead';
    }
    value(4; Updlock)
    {
        Caption = 'Updlock';
    }
}