import { BlockDivider, Typography, Navbar } from "../../components";
import Router from "next/router";
import {
  ArrowLeftOutlined,
  ManOutlined,
  WomanOutlined,
} from "@ant-design/icons";
import { useSelector } from "react-redux";
import {
  Toast,
  List,
  Image,
  Space,
  Button,
  DesensText,
} from "antd-mobile";
import { useEffect } from "react";
import ZoomLogo from "../../assets/logo/zoom.svg";
import BimbeeLogo from "../../assets/logo/bimbee.png";
import { dispatch } from "../../store";

export default function Profile() {
  const user = useSelector((state) => state.auth.user);
  const loading = useSelector(
    (state) => state.loading.effects.auth.getMyProfile,
  );

  const getMyProfile = async () => {
    await dispatch.auth.getMyProfile();
  };

  useEffect(() => {
    if (!user) {
      Toast.show("Dialihkan ke halaman login", 1);
      Router.push("/login");
    }
  }, [user]);

  useEffect(() => {
    getMyProfile();
  }, []);

  return (
    <div>
      <Navbar
        leftContent={
          <ArrowLeftOutlined onClick={() => Router.back()} />
        }
        rightContent={
          <div
            role="button"
            onClick={() => Router.push("/profile/edit")}
          >
            Edit
          </div>
        }
      >
        Profile
      </Navbar>
      <div
        className="container"
        style={{ "--container-bg-color": "#F5F5F9" }}
      >
        <BlockDivider transparent />
        <div>
          <div className="flex justify-center">
            <Image
              src={user.pic_url}
              fit="cover"
              height={192}
              width={192}
              style={{ borderRadius: "50%" }}
            />
          </div>
          <div className="flex justify-center mt-2">
            <Button
              onClick={() => Toast.show("Fitur akan segara hadir")}
            >
              Ganti Profile Picture
            </Button>
          </div>
        </div>
        <BlockDivider transparent />
        <div className="ml-2">INFORMASI DASAR</div>
        <List mode="card">
          <List.Item title="Nama Lengkap">
            <Typography loading={loading}>{user.name}</Typography>
          </List.Item>
          <List.Item title="Email">
            <Typography loading={loading}>{user.email}</Typography>
          </List.Item>
          <List.Item title="Nomor Handphone">
            <Typography loading={loading}>{user.phone}</Typography>
          </List.Item>
          <List.Item
            title="Jenis Kelamin"
            extra={
              user.gender === "female" ? (
                <WomanOutlined />
              ) : (
                <ManOutlined />
              )
            }
          >
            <Typography loading={loading}>
              {user.gender === "female" ? "Perempuan" : "Laki-laki"}
            </Typography>
          </List.Item>
        </List>
        <div className="ml-2">INFORMASI PENDIDIKAN</div>
        <List mode="card">
          <List.Item title="Tingkat Sekolah">
            <Typography
              loading={loading}
              style={{ textTransform: "uppercase" }}
            >
              {user.school || "-"}
            </Typography>
          </List.Item>
          <List.Item title="Kelas">
            <Typography loading={loading}>
              {user.grade || "-"}
            </Typography>
          </List.Item>
        </List>
        <div className="ml-2">LINK AKUN</div>
        <List mode="card">
          <List.Item
            title="Zoom User ID"
            extra={
              <Space style={{ alignItems: "center" }}>
                <Button
                  color={user.zoom_user_id ? "danger" : "primary"}
                  onClick={() =>
                    Toast.show(
                      "Silakan login dengan Zoom untuk menyabungkan",
                    )
                  }
                >
                  {user.zoom_user_id ? "Putuskan" : "Hubungkan"}
                </Button>
                <Image width={28} height={28} src={ZoomLogo} />
              </Space>
            }
          >
            {user.zoom_user_id ? (
              <DesensText
                text={user.zoom_user_id}
                desenseText={
                  "*****" + user.zoom_user_id.substr(4, 15) + "*****"
                }
              />
            ) : (
              "-"
            )}
          </List.Item>
          <List.Item
            title="Bimbee"
            extra={
              <Space style={{ alignItems: "center" }}>
                <Button
                  color={user.bimbee_username ? "danger" : "primary"}
                  onClick={() => Toast.show("Fitur segera hadir")}
                >
                  {user.bimbee_username ? "Putuskan" : "Hubungkan"}
                </Button>
                <Image
                  role="button"
                  onClick={() =>
                    user.bimbee_username &&
                    Router.push(
                      `https://bimbee.id/${user.bimbee_username}`,
                    )
                  }
                  width={28}
                  height={28}
                  src={BimbeeLogo}
                />
              </Space>
            }
          >
            <Typography loading={loading}>
              {user.bimbee_username || "-"}
            </Typography>
          </List.Item>
        </List>
        <div className="ml-2">ALAMAT</div>
        <List mode="card">
          <List.Item title="Provinsi">
            <Typography loading={loading}>
              {user.address_province || "-"}
            </Typography>
          </List.Item>
          <List.Item title="Kabupaten / Kota">
            <Typography loading={loading}>
              {user.address_city || "-"}
            </Typography>
          </List.Item>
          <List.Item title="Kecamatan">
            <Typography loading={loading}>
              {user.address_district || "-"}
            </Typography>
          </List.Item>
          <List.Item title="Alamat Lengkap">
            <Typography loading={loading}>
              {user.address_street || "-"}
            </Typography>
          </List.Item>
        </List>
      </div>
    </div>
  );
}
