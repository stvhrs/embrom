import persist from "@rematch/persist";
import loding from "@rematch/loading";
import { init } from "@rematch/core";
import storage from "redux-persist/lib/storage";

import auth from "../modules/Auth/model";
import meeting from "../modules/Meeting/model";
import regional from "../modules/Regional/model";

const store = init({
  models: { auth, regional, meeting },
  plugins: [
    loding(),
    persist({
      key: "root",
      storage,
      version: 1,
      // blacklist: ["loading", "transaction", "banner"],
    }),
  ],
});

export const { dispatch } = store;
export default store;
