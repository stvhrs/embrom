import { useEffect, useState } from "react";
import { useRouter } from "next/router";
const NotFound = () => {
  return <div>Not Found</div>;
};

export default function NotFoundWrapper({
  action,
  children,
  queryIdentifier = "id",
}) {
  const router = useRouter();
  const [is404, set404] = useState(false);

  useEffect(() => {
    const id = router.query[queryIdentifier];

    const fetch = async () => {
      if (id) {
        try {
          await action(id);
        } catch (err) {
          if (err.status === 404) set404(true);
        }
      }
    };

    fetch();
  }, [router.query]);

  return <>{is404 ? <NotFound /> : children}</>;
}
