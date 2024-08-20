page 50000 ar_Events
{
    Caption = 'Events';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ar_Event;

    layout
    {
        area(Content)
        {
            repeater(MainColumns)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}