import style from "./index.module.css";

export default function BlockDivider({ transparent }) {
  return (
    <div
      className={style.divider}
      style={
        transparent && {
          "--divider-bg-color": "transparent",
        }
      }
    />
  );
}
