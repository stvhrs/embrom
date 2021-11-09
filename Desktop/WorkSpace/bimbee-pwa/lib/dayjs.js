import dayjs from "dayjs";
import relativeTime from "dayjs/plugin/relativeTime";
import "dayjs/locale/id";

dayjs.locale("id");
dayjs.extend(relativeTime);

function getGreetingTime(m) {
  var g = null; //return g

  if (!m || !m.isValid()) {
    return;
  } //if we can't find a valid or filled moment, we return.

  var split_afternoon = 12; //24hr time to split the afternoon
  var split_evening = 17; //24hr time to split the evening
  var currentHour = parseFloat(m.format("HH"));

  if (
    currentHour >= split_afternoon &&
    currentHour <= split_evening
  ) {
    g = "Selamat Siang";
  } else if (currentHour >= split_evening) {
    g = "Selamat Malam";
  } else {
    g = "Selamat Pagi";
  }

  return g;
}

export { getGreetingTime };
export default dayjs;
