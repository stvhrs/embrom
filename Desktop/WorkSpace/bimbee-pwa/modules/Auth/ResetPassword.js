import { Button, Toast, Form, Input } from "antd-mobile";
import Router from "next/router";
import Link from "next/link";
import { useEffect } from "react";
import { useSelector } from "react-redux";
import { ArrowLeftOutlined } from "@ant-design/icons";

import { Wingpanel, BlockDivider, Navbar } from "../../components";
import { dispatch } from "../../store";

export default function ResetPassword() {
  const user = useSelector((state) => state.auth.user);
  const loading = useSelector(
    (state) => state.loading.effects.auth.forgetPassword,
  );

  const handleResetPassword = async (values) => {
    const { token, password } = values;

    try {
      await dispatch.auth.resetPassword({ token, password });
      Toast.show(
        "Kata sandi Anda berhasil diganti. Silakan login ulang",
      );
      Router.push("/login");
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
        Reset Kata Sandi
      </Navbar>
      <div className="container">
        <Wingpanel>
          Masukkan token yang diperoleh dari email serta setel ulang
          kata sandi Anda
        </Wingpanel>
        <Form
          onFinish={handleResetPassword}
          footer={
            <Button
              loading={loading}
              block
              type="submit"
              color="warning"
            >
              Reset Kata Sandi
            </Button>
          }
        >
          <Form.Item
            name="token"
            label="Kode Reset Password"
            rules={[{ required: true, type: "string", len: 6 }]}
          >
            <Input maxLength={6} label="Kode Reset" />
          </Form.Item>
          <Form.Item
            label="Masukkan kata sandi"
            name="password"
            rules={[{ required: true }]}
          >
            <Input label="Password" type="password" />
          </Form.Item>
          <Form.Item
            label="Ulangi kata sandi"
            name="repeat_password"
            rules={[
              { required: true },
              ({ getFieldValue }) => ({
                validator(_, value) {
                  if (!value || getFieldValue("password") === value) {
                    return Promise.resolve();
                  }
                  return Promise.reject(
                    new Error("Password yang Anda isikan tidak sama"),
                  );
                },
              }),
            ]}
          >
            <Input label="Ulangi Password" type="password" />
          </Form.Item>
        </Form>
        <BlockDivider transparent />
        <p className="text-center">
          Belum mendapatkan kode reset? Klik{" "}
          <Link href="/forgot-password">disini</Link> untuk
          mengirimkan lagi
        </p>
      </div>
    </div>
  );
}
