controladdin "ar_QuasarCalendarCtrl"
{
    Scripts =
        'https://cdn.jsdelivr.net/npm/vue@3/dist/vue.global.prod.js'
        , 'scripts/quasar.umd.js'
        , 'https://cdn.jsdelivr.net/npm/@quasar/quasar-ui-qcalendar@next/dist/QCalendarDay.umd.min.js'
        , 'https://cdn.jsdelivr.net/npm/@quasar/quasar-ui-qcalendar@next/dist/Timestamp.umd.min.js'
        , 'https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js'
        , 'scripts/startup.js';

    StyleSheets =
        'https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900|Material+Icons'
        , 'https://cdn.jsdelivr.net/npm/quasar@2/dist/quasar.prod.css'
        , 'https://cdn.jsdelivr.net/npm/@quasar/quasar-ui-qcalendar@next/dist/QCalendarDay.css'
        , 'https://cdn.jsdelivr.net/npm/@quasar/quasar-ui-qcalendar@next/dist/QCalendarVariables.css'
        , 'https://cdn.jsdelivr.net/npm/@quasar/quasar-ui-qcalendar@next/dist/QCalendarTransitions.css'
        , 'stylesheets/quasar-calendar-week.css';

    Images = 'html/index.html';

    StartupScript = 'scripts/startup.js';

    RequestedHeight = 500;
    RequestedWidth = 600;
    MinimumWidth = 400;
    MaximumWidth = 1000;
    MinimumHeight = 300;
    MaximumHeight = 2000;
    HorizontalStretch = true;
    VerticalStretch = true;

    event OnControlAddInReady();
}