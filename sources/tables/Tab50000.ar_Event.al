table 50000 ar_Event
{
    Caption = 'Events';
    DataClassification = CustomerContent;
    LookupPageId = ar_EventsList;
    DrillDownPageId = ar_EventsList;

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
        field(10; Title; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(11; Color; Enum ar_Colors)
        {
            DataClassification = CustomerContent;
        }
        field(12; Description; Text[100])
        {
            DataClassification = CustomerContent;
        }
        field(20; "Start Date"; DateTime)
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                Validate("Start Date", LookupDateTime("Start Date"));
            end;

            trigger OnValidate()
            begin
                if "End Date" = 0DT then
                    exit;

                if "Start Date" > "End Date" then
                    FieldError("Start Date", ErrStartDateMustBeEarlierThanEndDate);
            end;
        }
        field(21; "End Date"; DateTime)
        {
            DataClassification = CustomerContent;

            trigger OnLookup()
            begin
                Validate("End Date", LookupDateTime("End Date"));
            end;

            trigger OnValidate()
            begin
                if "Start Date" = 0DT then
                    exit;

                if "Start Date" > "End Date" then
                    FieldError("End Date", ErrEndDateMustBeLaterThanStartDate);
            end;
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
        ErrStartDateMustBeEarlierThanEndDate: Label 'must be earlier than end date.';
        ErrEndDateMustBeLaterThanStartDate: Label 'must be later than start date.';

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

    procedure LookupDateTime(InitialValue: DateTime): DateTime
    var
        DateTimeDialog: Page "Date-Time Dialog";
        NewValue: DateTime;
    begin
        DateTimeDialog.SetDateTime(InitialValue);

        if DateTimeDialog.RunModal() = Action::OK then begin
            NewValue := DateTimeDialog.GetDateTime();
            exit(NewValue);
        end
        else
            exit(InitialValue);
    end;
}