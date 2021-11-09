import style from "./index.module.css";

export default function WingPanel({ children, ...rest }) {
  return (
    <div className={style.wing} {...rest}>
      {children}
    </div>
  );
}
