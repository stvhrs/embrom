import Router from "next/router";


import { useSelector } from "react-redux";
import MeetingTile from "./MeetingTile";

import { useEffect, useState } from "react";
import { dispatch } from "../../store";

export default function Meeting() {
  // const { meetings } = useSelector((state) => state.meeting);
  // const getMettings = async () => {
  //   await dispatch.meeting.fetchMeetings();
  // };
  // useEffect(() => {
  //   getMettings();
  // }, []);
  let meetings = [
    {
      id: 4,
      uuid: "A8VQoBz3R46jAFt65xdt0Q==",
      meeting_id: 81513378439,
      join_url:
        "https://us02web.zoom.us/j/81513378439?pwd=bHZiREFpK00vc1FoUFZzekZKYkVCZz09",
      topic: "Pertemuan rutin Demo 2",
      type: 3,
      start_time: "2021-09-09T13:45:00Z",
      duration: 60,
      timezone: "Asia/Jakarta",
      agenda: "Pertemuan rutin Demo",
      password: "12345678",
      schedule_for: "",
      reccurrence: 3,
      approval_type: 0,
      image:
        "https://marvel-b1-cdn.bc0a.com/f00000000026007/resilienteducator.com/wp-content/uploads/sites/34/2014/11/math-teacher.jpg",
      school: "Universitas",
      grade: "XI",
      status: "",
      teacher: "Guru",
      subject: "",
    },
    {
      id: 3,
      uuid: "BfGMkoCHSpWMRzRM5rNX4A==",
      meeting_id: 84253745278,
      join_url:
        "https://us02web.zoom.us/j/84253745278?pwd=M0tGWEV6ekZBYXE5WTc0WHRQb1NoQT09",
      topic: "Bimbee No Fixed Time",
      type: 3,
      start_time: "2021-09-09T13:45:00Z",
      duration: 60,
      timezone: "",
      agenda: "Pertemuan rutin",
      password: "12345678",
      schedule_for: "",
      reccurrence: 3,
      approval_type: 0,
      image:
        "https://marvel-b1-cdn.bc0a.com/f00000000026007/resilienteducator.com/wp-content/uploads/sites/34/2014/11/math-teacher.jpg",
      school: "Universitas",
      grade: "XI",
      status: "",
      teacher: "Guru",
      subject: "",
    },
    {
      id: 2,
      uuid: "35e+E/gHRr+o82fL9W85Jw==",
      meeting_id: 88365188956,
      join_url:
        "https://us02web.zoom.us/j/88365188956?pwd=Qjl0Z2ZJUWU0cW12Smg1ZG1yS3VHUT09",
      topic: "Bimbee",
      type: 8,
      start_time: "2021-09-09T13:45:00Z",
      duration: 60,
      timezone: "",
      agenda: "Pertemuan rutin",
      password: "12345678",
      schedule_for: "",
      reccurrence: 8,
      approval_type: 0,
      image:
        "https://marvel-b1-cdn.bc0a.com/f00000000026007/resilienteducator.com/wp-content/uploads/sites/34/2014/11/math-teacher.jpg",
      school: "Universitas",
      grade: "XI",
      status: "",
      teacher: "Guru",
      subject: "",
    },
    {
      id: 1,
      uuid: "H9F9VZ9CQ8aUCG9zujEd3A==",
      meeting_id: 85656330738,
      join_url: "string",
      topic: "Bimbee",
      type: 8,
      start_time: "2021-09-09T13:45:00Z",
      duration: 60,
      timezone: "Asia/Jakarta",
      agenda: "Pertemuan rutin",
      password: "12345678",
      schedule_for: "",
      reccurrence: 8,
      approval_type: 0,
      image:
        "https://marvel-b1-cdn.bc0a.com/f00000000026007/resilienteducator.com/wp-content/uploads/sites/34/2014/11/math-teacher.jpg",
      school: "Universitas",
      grade: "XI",
      status: "",
      teacher: "Guru",
      subject: "",
    },
  ];
  let dummy = [{ id: 6 }, { id: 5 }, { id: 1 }, { id: 4 }];
  meetings.forEach((element) => {
    if (dummy.every((element2) => element2.id != element.id)) {
      element.status = false;
    } else {
      element.status = true;
    }
  });
  return (
    <>
      <div>
        {meetings.map((meeting) => (
          <div
            onClick={() => Router.push(`meeting/${meeting.id}`)}
            key={meeting.uuid}
          >
            <MeetingTile data={meeting} />
          </div>
        ))}
      </div>
    </>
  );
}
