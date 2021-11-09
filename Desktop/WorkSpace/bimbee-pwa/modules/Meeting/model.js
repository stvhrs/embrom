import { httpService } from "../../services";

export default {
  state: {
    meetings: [],
    meeting: {},
  },

  reducers: {
    reset: (state) => {
      return {
        ...state,
        meeting: {},
      };
    },

    success: (state, meetings) => {
      return {
        ...state,
        meetings,
      };
    },

    detailSuccess: (state, meeting) => {
      return {
        ...state,
        meeting,
      };
    },
  },

  effects: (dispatch) => ({
    async fetchMeetings() {
      const { data } = await httpService.get("pwa/active-meetings");
      dispatch.meeting.success(data.data);
    },

    async fetchMeeting(id) {
      dispatch.meeting.reset();
      try {
        const { data } = await httpService.get(`pwa/meetings/${id}`);
        dispatch.meeting.detailSuccess(data.data);
      } catch (err) {
        throw err.response;
      }
    },
  }),
};
