controladdin "ar_QuasarCalendarCtrl"
{
    Scripts =
        'scripts/vue.global.prod.js'
        , 'scripts/quasar.umd.prod.js'
        , 'scripts/QCalendarMonth.umd.min.js';

    StartupScript = 'scripts/startup.js';
    StyleSheets =
        'stylesheets/quasar.prod.css'
        , 'stylesheets/QCalendarMonth.min.css';

    event OnControlAddInReady();
}