import { Route, Routes } from 'react-router-dom'
import Contacts from './apps/contacts/Contacts'
import Details from './apps/details/Details'
import Home from './apps/home/Home'
import PhoneHeader from './components/header/PhoneHeader'
import NavigationBar from './components/navigationbar/NavigationBar'
import Notification from './components/notification/Notification'
import PhoneWrapper from './PhoneWrapper'

export default function Phone() {
  return (
    <>
      <PhoneWrapper>
        <PhoneHeader />
        <Notification />
        <div className="phone-app-container">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/details" element={<Details />} />
            <Route path="/contacts" element={<Contacts />} />
          </Routes>
        </div>
        <NavigationBar />
      </PhoneWrapper>
    </>
  )
}
