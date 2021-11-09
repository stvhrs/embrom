import { useEffect } from "react";
import { Loading, Toast } from "antd-mobile";
import { dispatch } from "../../store";
import Router from "next/router";

function RedirectZoom({ code }) {
  const requestToken = async (code) => {
    try {
      await dispatch.auth.zoomAuth(code);

      Toast.show("Login Berhasil");
      Router.push("/");
    } catch (err) {
      Toast.show(err);
      Router.push("/");
    }
  };

  useEffect(() => {
    requestToken(code);
  }, [code]);

  return (
    <div className="container">
      <div className="flex justify-center">
        <Loading />
      </div>
    </div>
  );
}

RedirectZoom.getInitialProps = async ({ query }) => {
  const { code } = query;
  return { code };
};

export default RedirectZoom;
