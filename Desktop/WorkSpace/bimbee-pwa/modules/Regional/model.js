import { httpService } from "../../services";

export default {
  state: {
    provinces: [],
    cities: [],
    districts: [],
  },

  reducers: {
    reset: (state) => {
      return {
        ...state,
        provinces: [],
        cities: [],
        districs: [],
      };
    },
    setProvinces: (state, provinces) => {
      return {
        ...state,
        provinces,
      };
    },
    setCities: (state, cities) => {
      return {
        ...state,
        cities,
      };
    },
    setDistricts: (state, districts) => {
      return {
        ...state,
        districts,
      };
    },
  },

  effects: (dispatch) => ({
    async fetchProvinces() {
      const { data } = await httpService.get("/regional/provinces");
      dispatch.regional.setProvinces(data.data);
    },

    async fetchCities(id) {
      const { data } = await httpService.get(
        "/regional/regencies-by-province",
        { province_id: id },
      );
      dispatch.regional.setCities(data.data);
    },

    async fetchDistricts(id) {
      const { data } = await httpService.get(
        "/regional/districts-by-regency",
        { regency_id: id },
      );
      dispatch.regional.setDistricts(data.data);
    },
  }),
};
