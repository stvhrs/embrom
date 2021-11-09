import { ClockCircleOutlined } from "@ant-design/icons";
import { Space } from "antd-mobile";
import { Wingpanel } from "../../components";
import styles from "./MeetingTile.module.css";
import dayjs from "../../lib/dayjs";
import { HomeOutlined, UserOutlined } from "@ant-design/icons";

const MeetingTile = (props) => {
  return (
    <Wingpanel>
      <div className={styles.shadow}>
        <div
          className={styles.bg}
          style={{
            backgroundImage: `url(${props.data.image})`,
          }}
        >
          <div className={styles.row}>
            <Space direction="vertical" style={{ width: "100%" }}>
              {[1].map((el) => (
                <div className={styles.card}>
                  <div style={{ flex: "1 1" }}>
                    <div
                      className="line-clamp text-sm"
                      style={{
                        right: 8,
                        top: 8,
                        position: "absolute",
                      }}
                    >
                      {dayjs(props.data.start_time).format(
                        "DD MMMM YYYY HH:MM",
                      ) || "-"}{" "}
                      <ClockCircleOutlined />
                    </div>

                    <div
                      style={{
                        backgroundColor: props.data.status
                          ? "orange"
                          : "green",
                      }}
                      className={styles.enrolled}
                    >
                      <div className="text-sm font-bold">
                        {props.data.status
                          ? "ENROLLED"
                          : "ENROLL NOW"}
                      </div>
                    </div>
                    <div className="text-xl font-bold">
                      {props.data.topic}
                    </div>
                    <div>Grade: {props.data.grade}</div>
                    <div
                      className="line-clamp font-bold"
                      style={{
                        right: 8,
                        bottom: 12,
                        position: "absolute",
                      }}
                    ></div>
                  </div>
                </div>
              ))}
            </Space>
          </div>
        </div>

        <div
          className="line-clamp font-bold"
          style={{
            marginLeft: 6,
          }}
        >
          <UserOutlined /> {props.data.teacher}
        </div>
        <div
          className="line-clamp font-bold"
          style={{
            marginLeft: 6,
          }}
        >
          <HomeOutlined /> {props.data.school}
        </div>
      </div>
    </Wingpanel>
  );
};
export default MeetingTile;
