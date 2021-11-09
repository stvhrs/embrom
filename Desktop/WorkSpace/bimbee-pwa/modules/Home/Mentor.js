import { Image, Space, Tag } from "antd-mobile";
import { Wingpanel } from "../../components";
import styles from "./Mentor.module.css";

export default function Mentor() {
  return (
    <Wingpanel>
      <div className="text-lg font-bold mb-2 flex items-center">
        <span>Mentor👨‍🏫</span>
      </div>
      <div className={styles.container}>
        {[2, 2, 2, 5].map((el) => (
          <div className={styles.itemOuter}>
            <div className={styles.itemInner}>
              <Image
                src="https://images.unsplash.com/photo-1548532928-b34e3be62fc6?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&fit=crop&h=200&w=200&ixid=eyJhcHBfaWQiOjE3Nzg0fQ"
                height={64}
                width={64}
                fit="cover"
                style={{ borderRadius: "50%" }}
              />
            </div>
          </div>
        ))}
      </div>
    </Wingpanel>
  );
}
