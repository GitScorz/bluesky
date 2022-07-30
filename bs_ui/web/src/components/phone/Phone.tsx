import { Route, Routes } from 'react-router-dom'
import { debugData } from '../../utils/debugData'
import Contacts from './apps/contacts/Contacts'
import Details from './apps/details/Details'
import Home from './apps/home/Home'
import PhoneHeader from './components/header/PhoneHeader'
import NavigationBar from './components/navigationbar/NavigationBar'
import PhoneWrapper from './PhoneWrapper'

debugData<UI.Phone.PhoneData>([
  {
    action: 'hud:phone:loadPhoneData',
    data: {
      serverId: 1,
      phoneNumber: "123456789",
      cash: 500,
      bank: 5000,
      hasDriverLicense: true,
    }
  }
]);

export default function Phone() {
  return (
    <>
      <PhoneWrapper>
        <PhoneHeader />
        <NavigationBar />
        <div className="phone-app-container">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/details" element={<Details />} />
            <Route path="/contacts" element={<Contacts />} />
          </Routes>
        </div>
      </PhoneWrapper>
    </>
  )
}
