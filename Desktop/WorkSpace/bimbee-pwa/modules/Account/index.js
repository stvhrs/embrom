import { List, Button, Dialog, NoticeBar, Image } from "antd-mobile";
import { BlockDivider, Wingpanel } from "../../components";
import {
  LogoutOutlined,
  MoneyCollectOutlined,
  ProfileOutlined,
  SettingOutlined,
  UserOutlined,
} from "@ant-design/icons";
import Link from "next/link";
import { dispatch } from "../../store";
import { useSelector } from "react-redux";
import Router from "next/router";

const Account = () => {
  const { user } = useSelector((state) => state.auth);
  const handleLogout = () => {
    Dialog.confirm({
      content: "Apakah kamu yakin akan logout?",
      confirmText: "Ya",
      cancelText: "Batal",
      onConfirm: async () => {
        dispatch.auth.logout();
      },
    });
  };

  return (
    <div>
      {!user ? (
        <>
          <Wingpanel>
            <div
              style={{
                fontSize: 18,
                fontWeight: 600,
                textAlign: "center",
              }}
            >
              Masuk untuk nikmati mudahnya donasi dan akses ke fitur
              lainnya!
            </div>
            <BlockDivider transparent />
            <Link href="/login">
              <Button block type="submit" color="warning">
                Login
              </Button>
            </Link>
            <BlockDivider transparent />
            <div className="text-center">
              Belum punya akun? <Link href="/register">Daftar</Link>
            </div>
          </Wingpanel>
          <BlockDivider />
        </>
      ) : (
        <>
          <List>
            {user && (
              <List.Item
                prefix={
                  <Image
                    height={48}
                    width={48}
                    fit="cover"
                    style={{ borderRadius: "50%" }}
                    src={user.pic_url}
                  />
                }
                onClick={() => Router.push("/profile")}
                description={user.email}
              >
                {user.name}
              </List.Item>
            )}
          </List>
          <BlockDivider />
        </>
      )}

      <List>
        <List.Item prefix={<ProfileOutlined />} onClick={() => {}}>
          Bantuan
        </List.Item>
        <List.Item
          prefix={<MoneyCollectOutlined />}
          onClick={() => {}}
        >
          Syarat dan Ketentuan
        </List.Item>
        <List.Item prefix={<SettingOutlined />} onClick={() => {}}>
          Tentang Aplikasi
        </List.Item>
        {user && (
          <List.Item
            prefix={<LogoutOutlined />}
            style={{ color: "red" }}
            onClick={handleLogout}
          >
            Logout
          </List.Item>
        )}
      </List>
    </div>
  );
};

export default Account;
