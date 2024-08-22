var url = Microsoft.Dynamics.NAV.GetImageResource("html/index.html");

$(document).ready(function() {
  $("#controlAddIn").load(url, function (response, status, xhr) {
    if (status === "error") {
      var msg = "Sorry but there was an error: ";
      $("#controlAddIn").html(msg + xhr.status + " " + xhr.statusText);
    } else {
      var controlAddIn = document.getElementById("controlAddIn");

      if (controlAddIn) {
        var parentBody = controlAddIn.parentNode;
        if (parentBody) { 
          parentBody.style.overflow = "scroll";
        }
      }

      var quasarScript = document.createElement('script')
      quasarScript.type = "text/javascript";
      quasarScript.src = 'https://cdn.jsdelivr.net/npm/quasar@2.16.9/dist/quasar.umd.prod.js';

      var target = window.frameElement;

      if (target) {
        target.setAttribute("scrolling", "yes");
        target.contentWindow.document.body.appendChild(quasarScript);
      }

      const { defineComponent, ref, computed, onMounted, onBeforeUnmount } = Vue;
      const {
        addToDate,
        parseTimestamp,
        isBetweenDates,
        today,
        parsed,
        parseDate,
        parseTime,
      } = QCalendarDay;

      // The function below is used to set up our demo data
      const CURRENT_DAY = new Date();
      function getCurrentDay(day) {
        const newDay = new Date(CURRENT_DAY);
        newDay.setDate(day);
        const tm = parseDate(newDay);
        return tm.date;
      }

      const calendarApp = {
        setup() {
          const selectedDate = ref(today()),
            calendar = ref(null),
            startDate = ref(today()),
            endDate = ref(today()),
            timeStartPos = ref(0),
            timeDurationHeight = ref(0),
            events = ref([
              {
                id: 1,
                title: "1st of the Month",
                details:
                  "Everything is funny as long as it is happening to someone else",
                date: getCurrentDay(1),
                bgcolor: "orange",
              },
              {
                id: 2,
                title: "Sisters Birthday",
                details: "Buy a nice present",
                date: getCurrentDay(4),
                bgcolor: "green",
                icon: "fas fa-birthday-cake",
              },
              {
                id: 3,
                title: "Meeting",
                details: "Time to pitch my idea to the company",
                date: getCurrentDay(21),
                time: "09:00",
                duration: 120,
                bgcolor: "red",
                icon: "fas fa-handshake",
              },
              {
                id: 4,
                title: "Lunch",
                details: "Company is paying!",
                date: getCurrentDay(21),
                time: "10:30",
                duration: 90,
                bgcolor: "purple",
                icon: "fas fa-hamburger",
              },
              {
                id: 5,
                title: "Visit mom",
                details: "Always a nice chat with mom",
                date: getCurrentDay(12),
                time: "10:00",
                duration: 360,
                bgcolor: "grey",
                icon: "fas fa-car",
              },
              {
                id: 6,
                title: "Conference",
                details: "Teaching Javascript 101",
                date: getCurrentDay(22),
                time: "10:00",
                duration: 90,
                bgcolor: "blue",
                icon: "fas fa-chalkboard-teacher",
              },
              {
                id: 6,
                title: "Lunch",
                details: "Lunch",
                date: getCurrentDay(22),
                time: "12:30",
                duration: 90,
                bgcolor: "purple",
                icon: "fas fa-chalkboard-teacher",
              },
              {
                id: 7,
                title: "Meet old friend",
                details: "Meet old friend",
                date: getCurrentDay(23),
                time: "09:00",
                duration: 120,
                bgcolor: "teal",
                icon: "fas fa-utensils",
              },
              {
                id: 8,
                title: "Fishing",
                details: "Time for some weekend R&R",
                date: getCurrentDay(27),
                bgcolor: "purple",
                icon: "fas fa-fish",
                days: 2,
              },
              {
                id: 9,
                title: "Vacation",
                details:
                  "Trails and hikes, going camping! Don't forget to bring bear spray!",
                date: getCurrentDay(29),
                bgcolor: "purple",
                icon: "fas fa-plane",
                days: 5,
              },
            ]);

          let intervalId = null;

          const eventsMap = computed(() => {
            const map = {};
            // this.events.forEach(event => (map[ event.date ] = map[ event.date ] || []).push(event))
            events.value.forEach((event) => {
              if (!map[event.date]) {
                map[event.date] = [];
              }
              map[event.date].push(event);
              if (event.days) {
                let timestamp = parseTimestamp(event.date);
                let days = event.days;
                do {
                  timestamp = addToDate(timestamp, { day: 1 });
                  if (!map[timestamp.date]) {
                    map[timestamp.date] = [];
                  }
                  map[timestamp.date].push(event);
                } while (--days > 0);
              }
            });
            return map;
          });

          function badgeClasses(event, type) {
            const isHeader = type === "header";
            return {
              [`text-white bg-${event.bgcolor}`]: true,
              "full-width": !isHeader && (!event.side || event.side === "full"),
              "left-side": !isHeader && event.side === "left",
              "right-side": !isHeader && event.side === "right",
              "rounded-border": true,
            };
          }

          function badgeStyles(
            event,
            type,
            timeStartPos = undefined,
            timeDurationHeight = undefined
          ) {
            const s = {};
            if (timeStartPos && timeDurationHeight) {
              s.top = timeStartPos(event.time) + "px";
              s.height = timeDurationHeight(event.duration) + "px";
            }
            s["align-items"] = "flex-start";
            return s;
          }

          function getEvents(dt) {
            // get all events for the specified date
            const events = this.eventsMap[dt] || [];

            if (events.length === 1) {
              events[0].side = "full";
            } else if (events.length === 2) {
              // this example does no more than 2 events per day
              // check if the two events overlap and if so, select
              // left or right side alignment to prevent overlap
              const startTime = addToDate(parsed(events[0].date), {
                minute: parseTime(events[0].time),
              });
              const endTime = addToDate(startTime, {
                minute: events[0].duration,
              });
              const startTime2 = addToDate(parsed(events[1].date), {
                minute: parseTime(events[1].time),
              });
              const endTime2 = addToDate(startTime2, {
                minute: events[1].duration,
              });
              if (
                isBetweenDates(startTime2, startTime, endTime, true) ||
                isBetweenDates(endTime2, startTime, endTime, true)
              ) {
                events[0].side = "left";
                events[1].side = "right";
              } else {
                events[0].side = "full";
                events[1].side = "full";
              }
            }

            return events;
          }

          function scrollToEvent(event) {
            calendar.value.scrollToTime(event.time, 350);
          }

          function onMoved(data) {
            console.log("onMoved", data);
          }

          function onChange(data) {
            startDate.value = data.start;
            endDate.value = data.end;
          }

          function onClickDate(data) {
            console.log("onClickDate", data);
          }

          function onClickDay(data) {
            console.log("onClickDay", data);
          }

          function onClickHeadDay(data) {
            console.log("onClickHeadDay", data);
          }

          function onToday() {
            selectedDate.value = today();
          }

          function onPrev() {
            calendar.value.prev();
          }

          function onNext() {
            calendar.value.next();
          }

          onMounted(() => {});

          return {
            selectedDate,
            calendar, // ref
            onMoved,
            onChange,
            onClickDate,
            onClickDay,
            onClickHeadDay,
            onToday,
            onPrev,
            onNext,
            scrollToEvent,
            badgeStyles,
            badgeClasses,
            getEvents,
            eventsMap,
            events,
          };
        },
      };
      const app = Vue.createApp(calendarApp);
      app.use(Quasar, { config: {} });
      app.component("QCalendarDay", QCalendarDay.QCalendarDay);
      app.mount("#q-calendarApp");
    };
})})