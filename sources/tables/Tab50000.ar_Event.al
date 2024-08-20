table 50000 ar_Event
{
    Caption = 'Events';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Event No."; Integer)
        {
            DataClassification = CustomerContent;

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
        key(Key1; "Event No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Event No.", Description)
        {
        }
        fieldgroup(Brick; "Event No.", Description)
        {
        }
    }
}