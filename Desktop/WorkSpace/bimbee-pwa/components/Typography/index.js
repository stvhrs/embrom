const Typography = ({
  loading,
  skeletonStyle,
  className,
  style,
  children,
}) => {
  if (loading) {
    return (
      <div
        style={{
          width: 120,
          height: 21,
          backgroundColor: "#eee",
          borderRadius: 4,
          ...skeletonStyle,
        }}
      />
    );
  }

  return (
    <div className={className} style={style}>
      {children}
    </div>
  );
};

export default Typography;
