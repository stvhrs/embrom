import { Form, Input, Button, List, Toast, Image } from "antd-mobile";
import { BlockDivider, Wingpanel, Navbar } from "../../components";
import Link from "next/link";
import { ArrowLeftOutlined } from "@ant-design/icons";
import Router from "next/router";
import { dispatch } from "../../store";
import { useSelector } from "react-redux";
import { useEffect } from "react";
import GoogleLogin from "react-google-login";
import GoogleLogo from "../../assets/logo/google.svg";
import ZoomLogo from "../../assets/logo/zoom.svg";
import BimbeeLogo from "../../assets/logo/bimbee.png";
import validateMessages from "../../lib/validateMessages";

const Login = () => {
  const user = useSelector((state) => state.auth.user);
  const loading = useSelector(
    (state) => state.loading.effects.auth.login,
  );

  const loadingGoogle = useSelector(
    (state) => state.loading.effects.auth.googleAuth,
  );

  const handleGoogleAuth = async (resp) => {
    try {
      await dispatch.auth.googleAuth(resp.tokenId);

      Toast.show("Login Berhasil");
      Router.push("/");
    } catch (err) {
      Toast.show(err);
    }
  };

  useEffect(() => {
    if (user) {
      Toast.show("Dialihkan ke beranda", 1);
      Router.push("/");
    }
  }, [user]);

  const handleLogin = async (values) => {
    const { email, password } = values;

    try {
      await dispatch.auth.login({ email, password });
      Toast.show("Login Berhasil");

      Router.push("/");
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
        Login
      </Navbar>
      <div className="container">
        <div
          style={{
            padding: 16,
            fontSize: 18,
            fontWeight: 600,
          }}
        >
          Masuk untuk nikmati mudahnya donasi dan akses ke fitur
          lainnya!
        </div>

        <Form
          validateMessages={validateMessages}
          onFinish={handleLogin}
          footer={
            <Button
              loading={loading}
              block
              type="submit"
              color="warning"
            >
              Login
            </Button>
          }
        >
          <Form.Item
            name="email"
            label="Email"
            rules={[{ required: true, type: "email" }]}
          >
            <Input placeholder="Masukkan email" />
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
          <List.Item>
            <div className="text-sm text-right">
              <Link href="/forgot-password">Lupa Kata Sandi</Link>
            </div>
          </List.Item>
        </Form>
        <div className="text-center">
          Belum punya akun? <Link href="/register">Daftar</Link>
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

export default Login;
