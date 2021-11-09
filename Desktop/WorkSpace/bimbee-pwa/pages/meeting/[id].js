import MeetingDetail from "../../modules/Meeting/MeetingDetail";
import { dispatch } from "../../store";
import NotFoundWrapper from "../../components/NotFoundWrapper";

export default function TransactionDetailPage() {
  return (
    <NotFoundWrapper
      action={dispatch.meeting.fetchMeeting}
      queryIdentifier="id"
    >
      <MeetingDetail />
    </NotFoundWrapper>
  );
}
