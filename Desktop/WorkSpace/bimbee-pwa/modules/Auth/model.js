import { httpService } from "../../services";
import {
  setUserCookies,
  setCookiesUser,
  removeUserCookies,
} from "../../lib/cokies";

export default {
  state: {
    user: null,
  },

  reducers: {
    setUserData: (state, user) => {
      return {
        ...state,
        user,
      };
    },

    removeUserData: (state) => {
      return {
        ...state,
        user: null,
      };
    },
  },

  effects: (dispatch) => ({
    async login({ email, password }) {
      try {
        const { data } = await httpService.post("login", {
          email,
          password,
        });

        httpService.setToken(data.data.token);
        setUserCookies({
          token: data.data.token,
          user: data.data.user,
        });
        dispatch.auth.setUserData(data.data.user);
      } catch (err) {
        throw err.response.data.message;
      }
    },

    async register(values) {
      try {
        const { data } = await httpService.post("register", values);

        httpService.setToken(data.data.token);
        setUserCookies({
          token: data.data.token,
          user: data.data.user,
        });
        dispatch.auth.setUserData(data.data.user);
      } catch (err) {
        throw err.response.data.errors;
      }
    },

    async googleAuth(token) {
      try {
        const { data } = await httpService.post("google-auth", {
          token,
        });

        httpService.setToken(data.data.token);
        setUserCookies({
          token: data.data.token,
          user: data.data.user,
        });
        dispatch.auth.setUserData(data.data.user);
      } catch (err) {
        throw err.response.data.message;
      }
    },

    async zoomAuth(token) {
      try {
        const { data } = await httpService.post("zoom-auth", {
          token,
        });

        httpService.setToken(data.data.token);
        setUserCookies({
          token: data.data.token,
          user: data.data.user,
        });
        dispatch.auth.setUserData(data.data.user);
      } catch (err) {
        throw err.response.data.message;
      }
    },

    async updateProfile(values) {
      try {
        const { data } = await httpService.put(
          "/pwa/profile",
          values,
        );

        setCookiesUser(data.data);
        dispatch.auth.setUserData(data.data);
      } catch (err) {
        throw err.response.data.message;
      }
    },

    async getMyProfile() {
      try {
        const { data } = await httpService.get("/pwa/users/me");

        setCookiesUser(data.data);
        dispatch.auth.setUserData(data.data);
      } catch (err) {
        throw err?.response?.data?.message;
      }
    },

    logout() {
      removeUserCookies();
      httpService.setToken(null);
      dispatch.auth.removeUserData();
    },

    async forgetPassword(email) {
      try {
        await httpService.post("forget-password", { email });
      } catch (err) {
        console.log(err.response.data.message);
        throw err.response.data.message;
      }
    },

    async resetPassword({ token, password }) {
      try {
        await httpService.post("reset-password", {
          token,
          new_password: password,
        });
      } catch (err) {
        console.log(err.response.data.message);
        throw err.response.data.message;
      }
    },
  }),
};
