import { Card } from "antd-mobile";
import { BlockDivider } from "../../components";
import Greeting from "./Greeting";
import LiveSession from "./LiveSession";
import Mentor from "./Mentor";

export default function Home() {
  return (
    <div style={{ paddingBottom: 60 }}>
      <Greeting />
      <BlockDivider />
      <LiveSession />
      <Mentor />
    </div>
  );
}
