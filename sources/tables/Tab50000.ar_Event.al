table 50000 ar_Event
{
    Caption = 'Events';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TestNoSeries();
            end;
        }
        field(2; "No. Series"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(10; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Start Date"; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(21; "End Date"; DateTime)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description)
        {
        }
        fieldgroup(Brick; "No.", Description)
        {
        }
    }
    var
        MarketingSetup: Record "Marketing Setup";
        NoSeries: Codeunit "No. Series";

    trigger OnInsert()
    var
        eventRec: Record ar_Event;
    begin
        if "No." <> '' then
            exit;

        MarketingSetup.Get();
        MarketingSetup.TestField(ar_EventNos);
        "No. Series" := MarketingSetup.ar_EventNos;
        if NoSeries.AreRelated("No. Series", xRec."No. Series") then
            "No. Series" := xRec."No. Series";
        "No." := NoSeries.GetNextNo("No. Series");
        eventRec.ReadIsolation(IsolationLevel::ReadUncommitted);
        eventRec.SetLoadFields("No.");
        while eventRec.Get("No.") do
            "No." := NoSeries.GetNextNo("No. Series");
    end;

    local procedure TestNoSeries()
    var
        eventRec: Record ar_Event;
    begin
        if "No." = xRec."No." then
            exit;

        eventRec.ReadIsolation(IsolationLevel::ReadUncommitted);
        eventRec.SetLoadFields("No.");
        if eventRec.Get(Rec."No.") then
            exit;

        MarketingSetup.Get();
        NoSeries.TestManual(MarketingSetup.ar_EventNos);
        "No. Series" := '';
    end;
}