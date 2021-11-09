import { Button, Input, Toast, Form } from "antd-mobile";
import Router from "next/router";
import Link from "next/link";
import { useEffect } from "react";
import { useSelector } from "react-redux";
import { ArrowLeftOutlined } from "@ant-design/icons";

import { BlockDivider, Navbar } from "../../components";
import { dispatch } from "../../store";

function ForgotPassword() {
  const user = useSelector((state) => state.auth.user);
  const loading = useSelector(
    (state) => state.loading.effects.auth.forgetPassword,
  );

  const handleForgotPassword = async (values) => {
    const { email } = values;

    try {
      await dispatch.auth.forgetPassword(email);
      Toast.show(
        "Email berisi petunjuk reset password sudah dikirim",
      );
      Router.push("/reset-password");
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

  return (
    <div>
      <Navbar
        leftContent={
          <ArrowLeftOutlined onClick={() => Router.back()} />
        }
      >
        Lupa Kata Sandi
      </Navbar>
      <div className="container">
        <Form
          onFinish={handleForgotPassword}
          footer={
            <Button block type="submit" color="warning">
              Kirim Permintaan
            </Button>
          }
        >
          <Form.Item
            name="email"
            label="Email"
            rules={[{ required: true }]}
          >
            <Input placeholder="Masukkan alamat email" />
          </Form.Item>
        </Form>
        <BlockDivider transparent />
        <p className="text-center">
          Sudah mendapatkan email? Klik
          <Link href="/reset-password">disini</Link> untuk mereset
          password
        </p>
      </div>
    </div>
  );
}

export default ForgotPassword;
