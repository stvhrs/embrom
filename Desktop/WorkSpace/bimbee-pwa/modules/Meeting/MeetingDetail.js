import {
  Image,
  Space,
  Popover,
  Tag,
  Button,
  Toast,
  Dialog,
  Loading
} from "antd-mobile";
import { useEffect, useState } from "react";
import dayjs from "../../lib/dayjs";
import { useSelector } from "react-redux";
import { Navbar, BlockDivider, Typography } from "../../components";
import Router, { useRouter } from "next/router";
import {
  ArrowLeftOutlined,
  BankOutlined,
  ClockCircleOutlined,
  FieldTimeOutlined,
  LinkOutlined,
  MoreOutlined,
  ShareAltOutlined,
  TagOutlined,
  UserOutlined,
} from "@ant-design/icons";
import WingPanel from "../../components/Wingpanel";
import ZoomLogo from "../../assets/logo/zoom.svg";
import { httpService } from "../../services";

function MeetingDetail() {
  const { meeting } = useSelector((state) => state.meeting);
  const loading = useSelector(
    (state) => state.loading.effects.meeting.fetchMeeting,
  );

  const [registered, setRegistered] = useState(false)
  const [loadingRegister, setLoadingRegister] = useState(false)
  const [zoomUrl, setZoomUrl] = useState()
  const router = useRouter()
  const { id } = router.query

  useEffect(async () => {
    const url = `pwa/registrations-by-meeting/${id}`
    try {
      const { data } = await httpService.get(url)
      setRegistered(true)
      setZoomUrl(data.data.join_url)
    } catch(error) {
      console.log(error.response.data.message)
    }
  },[id])

  const zoomDesc = () => (
    <WingPanel>
      <Typography className="font-bold text-lg flex items-center">
        <Image src={ZoomLogo} height={20} width={20} />
        Deskripsi Zoom
      </Typography>
      <Space className="mt-2" direction="vertical">
        <div>
          <div className="font-bold">Join URL</div>
          <div className="flex items-center">
            <LinkOutlined />
            <div className="text-gray ml-1">
              <a href={zoomUrl} target="_blank">{zoomUrl}</a>
            </div>
          </div>
        </div>
      </Space>
    </WingPanel>
  )

  const showZoomLinkDialog = () => {
    Dialog.show({
      content: zoomDesc(),
      closeOnMaskClick: true,
      closeOnAction: true,
      actions: [
        {
          key: 'Close',
          text: 'Tutup'
        }
      ]
    })
  }

  const handleRegister = async (status) => {
    const { id } = router.query
    const url = `pwa/registrations`
    setLoadingRegister(true)
    try {
      const { data } = await httpService.post(url, {
        meeting_id: parseInt(id)
      })
      setZoomUrl(data.data.join_url)
      setRegistered(true)
      Toast.show({
        icon: 'success',
        content: 'Pendaftaran Berhasil',
      })
      if(status){
        window.open(zoomUrl)
      }
    } catch(error) {
      console.log(error.response.data.message)
      Toast.show({
        icon: 'fail',
        content: 'Pendaftaran Gagal',
      })
    } finally {
      setLoadingRegister(false)
    }
  }

  return (
    <div>
      <Navbar
        mode="white"
        leftContent={
          <ArrowLeftOutlined onClick={() => Router.back()} />
        }
        rightContent={
          <Popover.Menu
            actions={[
              { text: "Bagikan" },
              { text: "Tambahkan Kalender" },
            ]}
            onSelect={(node) => Toast.show(`Fitur akan segera hadir`)}
            placement={"bottomRight"}
            trigger="click"
          >
            <MoreOutlined />
          </Popover.Menu>
        }
      >
        {meeting.topic}
      </Navbar>
      <div className="container" style={{ paddingBottom: 80 }}>
        <Image
          height={200}
          width="100%"
          fit="cover"
          src="https://marvel-b1-cdn.bc0a.com/f00000000026007/resilienteducator.com/wp-content/uploads/sites/34/2014/11/math-teacher.jpg"
        />

        <WingPanel>
          <div className="p-2 flex items-center">
            {[5, 4, 3, 2, 1].map((_, idx) => (
              <Image
                width={48}
                height={48}
                fit="cover"
                style={{
                  borderRadius: "50%",
                  zIndex: 5 - idx,
                  marginLeft: idx === 0 ? 0 : -24,
                  border: "2px solid white",
                }}
                src="https://marvel-b1-cdn.bc0a.com/f00000000026007/resilienteducator.com/wp-content/uploads/sites/34/2014/11/math-teacher.jpg"
              />
            ))}
            <div className="ml-1 font-bold">+5 partisipan</div>
          </div>
        </WingPanel>
        <WingPanel>
          <Space direction="vertical">
            <Space>
              <FieldTimeOutlined />
              <Typography
                skeletonStyle={{ height: 16 }}
                loading={loading}
              >
                {meeting.duration} menit
              </Typography>
            </Space>
            <Space>
              <ClockCircleOutlined />
              <Typography
                skeletonStyle={{ height: 16 }}
                loading={loading}
              >
                {dayjs(meeting.start_time).format(
                  "DD MMMM YYYY HH:MM",
                ) || "-"}
              </Typography>
            </Space>
            <Space>
              <UserOutlined />
              <Typography
                skeletonStyle={{ height: 16 }}
                loading={loading}
              >
                {meeting.teacher || "-"}
              </Typography>
            </Space>
            <Space>
              <BankOutlined />
              <Typography
                skeletonStyle={{ height: 16 }}
                loading={loading}
              >
                {` ${meeting.school || "-"} - ${
                  meeting.grade || "-"
                }`}
              </Typography>
            </Space>
            <Space>
              <Tag>{meeting.subject || "sss"}</Tag>
            </Space>
          </Space>
        </WingPanel>
        <BlockDivider />
        <WingPanel>
          <Typography className="font-bold text-lg">
            Deskripsi
          </Typography>
          <div>{meeting.agenda || "-"}</div>
        </WingPanel>
        <BlockDivider />
        { registered ? 
          <div className="sticky-bottom">
            <Button disabled={loading} onClick={showZoomLinkDialog} block color="primary">
              Gabung Kelas
            </Button>
          </div>
          :
          <div className="sticky-bottom">
            <div className="button-left">
              <Button disabled={loading} onClick={() => handleRegister(0)} block color="warning">
                { loadingRegister ?
                  <Loading color='white' /> :
                  'Daftar'
                }
              </Button>
            </div>
            <div className="button-right">
              <Button disabled={loading} onClick={() => {handleRegister(1)}} block color="success"> 
                { loadingRegister ?
                  <Loading color='white' /> :
                  'Daftar dan Ikut'
                }
              </Button>
            </div>
          </div>
        }
      </div>
    </div>
  );
}

export default MeetingDetail;
