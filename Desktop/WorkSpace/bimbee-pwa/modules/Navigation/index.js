import { useEffect, useState } from "react";
import { TabBar, Tabs } from "antd-mobile";
import Router from "next/router";
import Navbar from "../../components/Navbar";

import {
  HomeOutlined,
  MessageOutlined,
  UserOutlined,
} from "@ant-design/icons";

import Account from "../Account";
import Home from "../Home";
import Meeting from "../Meeting";

const menus = [
  {
    key: "home",
    title: "Home",
    icon: <HomeOutlined />,
    component: <Home />,
  },
  {
    key: "meeting",
    title: "Meeting",
    icon: <MessageOutlined />,
    component: <Meeting />,
  },
  {
    key: "account",
    title: "Akun",
    icon: <UserOutlined />,
    component: <Account />,
  },
];

function Navigation({ tab }) {
  const [activeTab, setActiveTab] = useState(tab);

  useEffect(() => {
    setActiveTab(tab);
  }, [tab]);

  return (
    <>
      <Navbar>
        <span style={{ textTransform: "capitalize" }}>
          {tab || "Home"}
        </span>
      </Navbar>
      <div className="container">
        <TabBar
          activeKey={activeTab}
          defaultActiveKey={activeTab}
          onChange={(key) => Router.push(`?tab=${key}`)}
        >
          {menus.map((menu) => (
            <TabBar.Item
              title={menu.title}
              key={menu.key}
              icon={menu.icon}
            />
          ))}
        </TabBar>
        <Tabs activeKey={activeTab} defaultActiveKey={activeTab}>
          {menus.map((menu) => (
            <Tabs.TabPane key={menu.key}>
              {menu.component}
            </Tabs.TabPane>
          ))}
        </Tabs>
      </div>
    </>
  );
}

Navigation.getInitialProps = async ({ query }) => {
  const { tab } = query;
  return { tab };
};

export default Navigation;
