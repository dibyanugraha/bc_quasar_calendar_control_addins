page 50001 ar_EventsCalendar
{
    Caption = 'Events Calendar';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Tasks;
    SourceTable = ar_Event;

    layout
    {
        area(Content)
        {
            group(EventsCalendarTitle)
            {
                Caption = 'Events Calendar';
                usercontrol(EventsCalendar; ar_QuasarCalendarCtrl)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}