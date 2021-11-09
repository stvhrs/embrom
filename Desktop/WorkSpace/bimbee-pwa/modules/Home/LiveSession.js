import { ClockCircleOutlined } from "@ant-design/icons";
import { Image, Space, Tag } from "antd-mobile";
import { Wingpanel } from "../../components";
import styles from "./LiveSession.module.css";

export default function LiveSession() {
  return (
    <Wingpanel>
      <div className="text-lg font-bold mb-2 flex items-center">
        <span>Live Session</span>
        <Tag className="ml-1" color="green">
          <span className={styles.blink}>• </span> LIVE
        </Tag>
      </div>
      {/* <div>Tidak Ada Live Session untuk saat ini</div> */}
      <Space direction="vertical" style={{ width: "100%" }}>
        {[1].map((el) => (
          <div className={styles.card}>
            <Image
              height={72}
              width={72}
              style={{ borderRadius: 4 }}
            />
            <div style={{ flex: "1 1", marginLeft: 8 }}>
              <div className="text-lg line-clamp">
                Nice nice, that’s a good start
              </div>
              <div className="line-clamp">Matematika</div>
              <div className="line-clamp font-bold">Pengajar</div>
              <div className="flex justify-between">
                <Space>
                  <Tag>XII SMA</Tag>
                  <Tag>
                    <ClockCircleOutlined /> 12.00
                  </Tag>
                </Space>
                <Space>
                  <Tag color="green">
                    <span className={styles.blink}>• </span> LIVE
                  </Tag>
                </Space>
              </div>
            </div>
          </div>
        ))}
      </Space>
    </Wingpanel>
  );
}
