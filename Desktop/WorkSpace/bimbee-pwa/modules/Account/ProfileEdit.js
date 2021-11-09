import { BlockDivider, Navbar } from "../../components";
import Router from "next/router";
import {
  ArrowLeftOutlined,
  CaretDownOutlined,
} from "@ant-design/icons";
import {
  Form,
  Steps,
  Button,
  Input,
  List,
  Selector,
  Toast,
  TextArea,
} from "antd-mobile";
import { useEffect, useState } from "react";
import { useSelector } from "react-redux";
import { dispatch } from "../../store";
import { isJSON } from "../../lib/helper";
const InputGroup = ({
  prefix,
  extra,
  onChange,
  value,
  placeholder,
}) => {
  return (
    <List
      style={{
        "--prefix-width": "2.2em",
      }}
    >
      <List.Item
        prefix={prefix}
        extra={extra}
        style={{ paddingLeft: 0 }}
      >
        <Input
          value={value}
          onChange={onChange}
          placeholder={placeholder}
          clearable
        />
      </List.Item>
    </List>
  );
};

const Select = ({ value, options, placeholder, onChange }) => {
  const handleChange = (e) => {
    onChange(e.target.value);
  };

  return (
    <div className="adm-input-wrapper">
      <select
        placeholder={placeholder}
        value={value}
        onChange={handleChange}
        className="adm-input"
      >
        {options?.map((el) => (
          <option value={el.value}>{el.label}</option>
        ))}
      </select>
      <CaretDownOutlined />
    </div>
  );
};

function ProfileEdit({ step }) {
  const [formStep, setFormStep] = useState(0);

  const user = useSelector((state) => state.auth.user);
  const loading = useSelector(
    (state) => state.loading.effects.auth.getMyProfile,
  );
  const { provinces, cities, districts } = useSelector(
    (state) => state.regional,
  );

  const [basicForm] = Form.useForm();
  const [educationForm] = Form.useForm();
  const [dommicileForm] = Form.useForm();

  const handleSaveBasic = async (values) => {
    try {
      await dispatch.auth.updateProfile({
        ...values,
        gender: values.gender?.[0],
      });
      Toast.show("Berhasil disimpan");
      Router.push(`/profile/edit?step=${formStep + 1}`);
    } catch (err) {
      Toast.show({
        icon: "fail",
        content: err,
      });
    }
  };

  const handleSaveEducation = async (values) => {
    try {
      await dispatch.auth.updateProfile({
        school: values.school?.[0],
        grade: values.grade?.[0],
      });
      Toast.show("Berhasil disimpan");
      Router.push(`/profile/edit?step=${formStep + 1}`);
    } catch (err) {
      Toast.show({
        icon: "fail",
        content: err,
      });
    }
  };

  const handleChangeProvince = async (value) => {
    const { id } = JSON.parse(value);
    await dispatch.regional.fetchCities(id);
  };

  const handleChangeCity = async (value) => {
    const { id } = JSON.parse(value);
    await dispatch.regional.fetchDistricts(id);
  };

  const handleSaveDomicile = async (values) => {
    const payload = {
      address_street: values.address_street,
    };
    if (isJSON(values.address_province)) {
      payload = {
        ...payload,
        address_province: JSON.parse(values.address_province)?.name,
      };
    }
    if (isJSON(values.address_city)) {
      payload = {
        ...payload,
        address_city: JSON.parse(values.address_city)?.name,
      };
    }
    if (isJSON(values.address_district)) {
      payload = {
        ...payload,
        address_district: JSON.parse(values.address_district)?.name,
      };
    }

    try {
      await dispatch.auth.updateProfile(payload);
      Toast.show("Berhasil disimpan");
      Router.push(`/profile`);
    } catch (err) {
      Toast.show({
        icon: "fail",
        content: err,
      });
    }
  };

  const getMyProfile = async () => {
    await dispatch.auth.getMyProfile();
  };

  const fetchProvince = async () => {
    await dispatch.regional.fetchProvinces();
  };

  useEffect(() => {
    if (!user) {
      Toast.show("Dialihkan ke halaman login", 1);
      Router.push("/login");
    } else {
      basicForm.setFieldsValue({
        name: user.name,
        email: user.email,
        phone: user.phone,
        gender: [user.gender],
      });
      educationForm.setFieldsValue({
        school: [user.school],
        grade: [user.grade],
      });
      dommicileForm.setFieldsValue({
        address_street: user.address_street,
        address_province: user.address_province,
        address_city: user.address_city,
        address_district: user.address_district,
      });
    }
  }, [user]);

  useEffect(() => {
    getMyProfile();
    fetchProvince();
  }, []);

  useEffect(() => {
    Toast.show({
      icon: "loading",
      content: "Memuat data",
    });
  }, [loading]);

  useEffect(() => {
    if (step === "0" || step === "1" || step === "2") {
      const stepInt = parseInt(step);
      setFormStep(stepInt);
    } else {
      setFormStep(0);
    }
  }, [step]);

  return (
    <div>
      <Navbar
        leftContent={
          <ArrowLeftOutlined onClick={() => Router.back()} />
        }
      >
        Ubah Data
      </Navbar>
      <div className="container">
        <Steps current={formStep}>
          <Steps.Step title="Informasi" description="Dasar" />
          <Steps.Step title="Informasi" description="Pendidikan" />
          <Steps.Step title="Informasi" description="Domisili" />
        </Steps>
        <BlockDivider />
        {formStep === 0 && (
          <Form
            form={basicForm}
            onFinish={handleSaveBasic}
            footer={
              <Button block color="primary" type="submit">
                Simpan dan Selanjutnya
              </Button>
            }
          >
            <Form.Item
              name="email"
              disabled
              label="Email"
              rules={[{ required: true, type: "email" }]}
            >
              <Input placeholder="Masukkan email" />
            </Form.Item>
            <Form.Item
              name="name"
              label="Nama"
              rules={[{ required: true }]}
            >
              <Input placeholder="Masukkan nama" />
            </Form.Item>

            <Form.Item
              name="phone"
              label="Nomor Handphone (Whatsapp)"
              rules={[{ required: true }]}
            >
              <InputGroup
                prefix="+62"
                placeholder="Masukkan nomor Whatsapp"
              />
            </Form.Item>
            <Form.Item
              name="gender"
              label="Jenis Kelamin"
              rules={[{ required: true }]}
            >
              <Selector
                columns={2}
                options={[
                  {
                    value: "female",
                    label: "Perempuan",
                  },
                  {
                    value: "male",
                    label: "Laki-laki",
                  },
                ]}
              />
            </Form.Item>
          </Form>
        )}
        {formStep === 1 && (
          <Form
            form={educationForm}
            onFinish={handleSaveEducation}
            footer={
              <Button block color="primary" type="submit">
                Simpan dan Selanjutnya
              </Button>
            }
          >
            <Form.Item
              name="school"
              label="Tingkat Pendidikan"
              rules={[{ required: true }]}
            >
              <Selector
                columns={4}
                onChange={() =>
                  educationForm.setFieldsValue({ grade: null })
                }
                options={[
                  {
                    value: "sd",
                    label: "SD",
                  },
                  {
                    value: "smp",
                    label: "SMP",
                  },
                  {
                    value: "sma",
                    label: "SMA",
                  },
                  {
                    value: "general",
                    label: "Umum",
                  },
                ]}
              />
            </Form.Item>
            <Form.Item shouldUpdate noStyle>
              {({ getFieldValue }) => {
                if (getFieldValue("school")?.[0] === "sd") {
                  return (
                    <Form.Item
                      label="Pilih Kelas"
                      name="grade"
                      rules={[{ required: true }]}
                    >
                      <Selector
                        columns={3}
                        options={["1", "2", "3", "4", "5", "6"].map(
                          (el) => ({
                            value: el,
                            label: el,
                          }),
                        )}
                      />
                    </Form.Item>
                  );
                }
                if (getFieldValue("school")?.[0] === "smp") {
                  return (
                    <Form.Item
                      label="Pilih Kelas"
                      name="grade"
                      rules={[{ required: true }]}
                    >
                      <Selector
                        columns={3}
                        options={["7", "8", "9"].map((el) => ({
                          value: el,
                          label: el,
                        }))}
                      />
                    </Form.Item>
                  );
                }
                if (getFieldValue("school")?.[0] === "sma") {
                  return (
                    <Form.Item
                      label="Pilih Kelas"
                      name="grade"
                      rules={[{ required: true }]}
                    >
                      <Selector
                        columns={3}
                        options={["10", "11", "12"].map((el) => ({
                          value: el,
                          label: el,
                        }))}
                      />
                    </Form.Item>
                  );
                }
              }}
            </Form.Item>
          </Form>
        )}
        {formStep === 2 && (
          <Form
            form={dommicileForm}
            onFinish={handleSaveDomicile}
            footer={
              <Button block color="primary" type="submit">
                Simpan
              </Button>
            }
          >
            <Form.Item
              name="address_province"
              label="Provinsi"
              rules={[{ required: true }]}
            >
              <Select
                onChange={handleChangeProvince}
                options={provinces.map((province) => ({
                  label: province.name,
                  value: JSON.stringify(province),
                }))}
              />
            </Form.Item>
            <Form.Item
              name="address_city"
              label="Kota/Kabupaten"
              rules={[{ required: true }]}
            >
              <Select
                onChange={handleChangeCity}
                options={cities.map((city) => ({
                  label: city.name,
                  value: JSON.stringify(city),
                }))}
              />
            </Form.Item>
            <Form.Item
              name="address_district"
              label="Kecamatan"
              rules={[{ required: true }]}
            >
              <Select
                options={districts.map((district) => ({
                  label: district.name,
                  value: JSON.stringify(district),
                }))}
              />
            </Form.Item>
            <Form.Item
              name="address_street"
              label="Alamat"
              rules={[{ required: true }]}
            >
              <TextArea placeholder="Alamat lengkap" />
            </Form.Item>
          </Form>
        )}
      </div>
    </div>
  );
}

ProfileEdit.getInitialProps = async ({ query }) => {
  const { step } = query;
  return { step };
};

export default ProfileEdit;
