import dayjs, { getGreetingTime } from "../../lib/dayjs";
import Link from "next/link";
import { Image } from "antd-mobile";
import logoMorning from "../../assets/greeting/icons8-morning.png";
import logoDay from "../../assets/greeting/icons8-day.png";
import logoNight from "../../assets/greeting/icons8-night.png";
import { useSelector } from "react-redux";
import { Wingpanel } from "../../components";
import { LoginOutlined } from "@ant-design/icons";

function icon(time) {
  switch (time) {
    case "Selamat Siang":
      return logoDay;
    case "Selamat Pagi":
      return logoMorning;
    default:
      return logoNight;
  }
}
export default function LoginPrompt({}) {
  const { user } = useSelector((state) => state.auth);

  if (user) {
    return (
      <Wingpanel>
        <div className="flex justify-between items-center">
          <div>
            <div className="text-xl font-bold">
              {`Hi, ${user.name}`}{" "}
            </div>
            {`${getGreetingTime(dayjs())}`}
          </div>
          <Image
            height={48}
            width={48}
            src={icon(getGreetingTime(dayjs()))}
          />
        </div>
      </Wingpanel>
    );
  }

  return (
    <Link href="/login">
      <Wingpanel>
        <div className="flex items-center">
          <LoginOutlined style={{ marginRight: 12, fontSize: 24 }} />
          <div>
            <div className="text-xl font-bold">Masuk / Register</div>
            <div>Untuk melanjutkan menggukan aplikasi</div>
          </div>
        </div>
      </Wingpanel>
    </Link>
  );
}
