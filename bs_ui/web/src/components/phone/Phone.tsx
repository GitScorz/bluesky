import { Route, Routes } from 'react-router-dom'
import Home from './apps/home/Home'
import PhoneWrapper from './PhoneWrapper'

export default function Phone() {
  return (
    <>
      <PhoneWrapper>
        <div className="phone-app-container">
          <Routes>
            <Route path="/" element={<Home />} />
          </Routes>
        </div>
      </PhoneWrapper>
    </>
  )
}
