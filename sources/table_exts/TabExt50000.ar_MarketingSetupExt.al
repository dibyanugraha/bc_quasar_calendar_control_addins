tableextension 50000 ar_MarketingSetupExt extends "Marketing Setup"
{
    fields
    {
        field(50000; ar_EventNos; Code[20])
        {
            Caption = 'Event Nos.';
            TableRelation = "No. Series";
        }
    }
}