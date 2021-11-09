import { Form, Input, Button, Toast, List, Image } from "antd-mobile";
import { BlockDivider, Wingpanel } from "../../components";
import Navbar from "../../components/Navbar";
import Link from "next/link";
import { ArrowLeftOutlined } from "@ant-design/icons";
import Router from "next/router";
import { useSelector } from "react-redux";
import GoogleLogin from "react-google-login";
import GoogleLogo from "../../assets/logo/google.svg";
import BimbeeLogo from "../../assets/logo/bimbee.png";
import ZoomLogo from "../../assets/logo/zoom.svg";
import { dispatch } from "../../store";

const InputGroup = ({
  prefix,
  extra,
  onChange,
  value,
  placeholder,
}) => {
  return (
    <List
      style={{
        "--prefix-width": "2.2em",
      }}
    >
      <List.Item
        prefix={prefix}
        extra={extra}
        style={{ paddingLeft: 0 }}
      >
        <Input
          value={value}
          onChange={onChange}
          placeholder={placeholder}
          clearable
        />
      </List.Item>
    </List>
  );
};

const Register = () => {
  const loadingGoogle = useSelector(
    (state) => state.loading.effects.auth.googleAuth,
  );

  const loading = useSelector(
    (state) => state.loading.effects.auth.register,
  );

  const handleRegister = async (values) => {
    try {
      await dispatch.auth.register(values);
      Toast.show("Register Berhasil");

      Router.push("/");
    } catch (err) {
      Toast.show(err);
    }
  };

  const handleGoogleAuth = async (resp) => {
    try {
      await dispatch.auth.googleAuth(resp.tokenId);

      Toast.show("Login Berhasil");
      Router.push("/?tab=account");
    } catch (err) {
      Toast.show(err);
    }
  };
  return (
    <div>
      <Navbar
        leftContent={
          <ArrowLeftOutlined onClick={() => Router.back()} />
        }
      >
        Register
      </Navbar>
      <div className="container">
        <div
          style={{
            padding: 16,
            fontSize: 18,
            fontWeight: 600,
          }}
        >
          Pendaftaran
        </div>
        <Form
          onFinish={handleRegister}
          footer={
            <Button
              block
              type="submit"
              color="warning"
              loading={loading}
            >
              Daftar
            </Button>
          }
        >
          <Form.Item
            name="name"
            label="Nama"
            rules={[{ required: true }]}
          >
            <Input placeholder="Masukkan nama lengkap" />
          </Form.Item>
          <Form.Item
            name="email"
            label="Email"
            rules={[{ required: true, type: "email" }]}
          >
            <Input placeholder="Masukkan email" />
          </Form.Item>
          <Form.Item
            name="phone"
            label="Nomor Handphone (Whatsapp)"
            rules={[{ required: true }]}
          >
            <InputGroup
              prefix="+62"
              placeholder="Masukkan nomor Whatsapp"
            />
          </Form.Item>
          <Form.Item
            name="password"
            label="Password"
            rules={[{ required: true }]}
          >
            <Input
              type="password"
              placeholder="Masukkan kata sandi"
            />
          </Form.Item>
          <Form.Item
            name="repeat"
            label="Ulangi Password"
            rules={[{ required: true }]}
          >
            <Input type="password" placeholder="Ulangi kata sandi" />
          </Form.Item>
        </Form>
        <div className="text-center">
          Sudah punya akun? <Link href="/login">Masuk</Link>
        </div>
        <BlockDivider transparent />
        <BlockDivider />
        <Wingpanel>
          <div
            style={{
              fontSize: 18,
              fontWeight: 600,
              textAlign: "center",
            }}
          >
            Atau lebih cepat
          </div>
          <BlockDivider transparent />
          <GoogleLogin
            clientId={process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID}
            buttonText="Masuk dengan Google"
            onSuccess={handleGoogleAuth}
            cookiePolicy={"single_host_origin"}
            render={({ onClick, disabled }) => (
              <Button
                block
                onClick={onClick}
                disabled={disabled}
                style={{
                  display: "flex",
                  justifyContent: "center",
                  alignItems: "center",
                }}
              >
                <Image width={16} height={16} src={GoogleLogo} />
                <div style={{ flex: "1 1" }}>Login dengan Google</div>
              </Button>
            )}
          />
          <BlockDivider transparent />
          <Button
            block
            onClick={() =>
              Router.push(
                "https://zoom.us/oauth/authorize?response_type=code&client_id=sMh7UU4vQ8yjQIJbYj3klg&redirect_uri=http://localhost:3000/zoom-auth",
              )
            }
            style={{
              display: "flex",
              justifyContent: "center",
              alignItems: "center",
            }}
          >
            <Image width={16} height={16} src={ZoomLogo} />
            <div style={{ flex: "1 1" }}>Login dengan Zoom</div>
          </Button>
          <BlockDivider transparent />
          <Button
            block
            disabled
            style={{
              display: "flex",
              justifyContent: "center",
              alignItems: "center",
            }}
          >
            <Image width={16} height={16} src={BimbeeLogo} />
            <div style={{ flex: "1 1" }}>Login dengan Bimbee</div>
          </Button>
        </Wingpanel>
      </div>
    </div>
  );
};

export default Register;
