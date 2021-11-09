import navStyle from "./index.module.css";

export default function Navbar({
  leftContent,
  children,
  rightContent,
  mode = "dark",
  style,
}) {
  let additionalStyle = {
    ...style,
  };

  if (mode === "dark") {
    additionalStyle = {
      ...additionalStyle,
      "--nav-bg-color": "#00AEEF",
      "--nav-color": "#FFF",
    };
  } else if (mode === "transparent") {
    additionalStyle = {
      ...additionalStyle,
      "--nav-bg-color": "transparent",
    };
  } else if (mode === "white") {
    additionalStyle = {
      ...additionalStyle,
      "--nav-bg-color": "#FFF",
    };
  }

  return (
    <div className={navStyle.navbar} style={additionalStyle}>
      {leftContent && (
        <div className={navStyle.navbarLeft}>{leftContent}</div>
      )}
      <div className={navStyle.navbarTitle}>{children}</div>
      {rightContent && (
        <div className={navStyle.navbarRight}>{rightContent}</div>
      )}
    </div>
  );
}
