import Cookies from "js-cookie";

const setUserCookies = ({ token, user }) => {
  Cookies.set("token", token);
  Cookies.set("user", JSON.stringify(user));
};

const setCookiesUser = (user) => {
  Cookies.set("user", JSON.stringify(user));
};

const removeUserCookies = () => {
  Cookies.remove("token");
  Cookies.remove("user");
};

const getUserCookies = () => {
  return {
    token: Cookies.get("token") || null,
    user: Cookies.get("user")
      ? JSON.parse(Cookies.get("user"))
      : null,
  };
};

export {
  setUserCookies,
  setCookiesUser,
  removeUserCookies,
  getUserCookies,
};
