import axios from "axios";

export default class Http {
  constructor() {
    this._axios = axios.create({
      baseURL: process.env.NEXT_PUBLIC_BASE_URL,
    });
  }

  setToken(token) {
    if (token !== null) {
      this._axios.defaults.headers.common.Authorization = `Bearer ${token}`;
    } else {
      delete this._axios.defaults.headers.common.Authorization;
    }
  }

  get(url, params = {}, responseType = "json") {
    try {
      return this._axios.request({
        method: "get",
        url,
        params,
        responseType,
      });
    } catch (error) {
      throw new Error(error);
    }
  }

  post(url, data, config = {}) {
    try {
      return this._axios.request({
        method: "post",
        url,
        data,
        ...config,
      });
    } catch (error) {
      throw new Error(error);
    }
  }

  put(url, data) {
    try {
      return this._axios.request({
        method: "put",
        url,
        data,
      });
    } catch (error) {
      throw new Error(error.message);
    }
  }

  delete(url, data = null) {
    try {
      return this._axios.request({
        method: "delete",
        url,
        data,
      });
    } catch (error) {
      throw new Error(error.message);
    }
  }
}
