import React, { useEffect, useState } from 'react';
import { connect, useSelector } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { makeStyles, Tabs, Tab } from '@material-ui/core';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import DialpadIcon from '@material-ui/icons/Dialpad';
import PhoneInTalkIcon from '@material-ui/icons/PhoneInTalk';
import PersonPinIcon from '@material-ui/icons/PersonPin';

import Keypad from './keypad';
import RecentList from './recent-index';
import ContactsLIst from './contacts';

import { readCalls } from './action';

const useStyles = makeStyles(theme => ({
    wrapper: {
        height: '100%',
        background: theme.palette.secondary.main,
    },
    content: {
        height: '90.5%',
        overflowY: 'auto',
        overflowX: 'hidden',
        '&::-webkit-scrollbar': {
            width: 6,
        },
        '&::-webkit-scrollbar-thumb': {
            background: '#ffffff52',
        },
        '&::-webkit-scrollbar-thumb:hover': {
            background: theme.palette.primary.main,
        },
        '&::-webkit-scrollbar-track': {
            background: 'transparent',
        },
    },
    tabPanel: {
        height: '100%',
    },
    phoneTab: {
        minWidth: '33.3%',
    }
}));

export default connect(null, { readCalls })((props) => {
    const classes = useStyles();
    const navigate = useNavigate()
    const callData = useSelector(state => state.call.call);
    const callHistory = useSelector(state => state.data.data.calls);

    useEffect(() => {
        if (callHistory.filter(c => c.unread).length > 0) {
            props.readCalls()
        }
    }, [callHistory]);

    const [activeTab, setActiveTab] = useState(1);

    useEffect(() => {
        if (callData != null && callData.state !== 1) {
            navigate(`/apps/phone/call/${callData.number}`);
        }
    }, []);

    const handleTabChange = (event, tab) => {
        setActiveTab(tab);
    };

    return (
        <div className={classes.wrapper}>
            <div className={classes.content}>
                <div
                    className={classes.tabPanel}
                    role="tabpanel"
                    hidden={activeTab !== 0}
                    id='recent'
                    >
                    {activeTab === 0 && (
                        <RecentList />
                    )}
                </div>
                <div
                    className={classes.tabPanel}
                    role="tabpanel"
                    hidden={activeTab !== 1}
                    id='keypad'
                    >
                    {activeTab === 1 && (
                        <Keypad />
                    )}
                </div>
                <div
                    className={classes.tabPanel}
                    role="tabpanel"
                    hidden={activeTab !== 2}
                    id='contacts'
                    >
                    {activeTab === 2 && (
                        <ContactsLIst />
                    )}
                </div>
            </div>
            <div className={classes.tabs}>
                <Tabs
                    value={activeTab}
                    onChange={handleTabChange}
                    indicatorColor="primary"
                    textColor="primary"
                    variant="scrollable"
                    scrollButtons="off"
                >
                    <Tab className={classes.phoneTab} label="Recent" icon={<PhoneInTalkIcon />} />
                    <Tab className={classes.phoneTab} label="Keypad" icon={<DialpadIcon />}/>
                    <Tab className={classes.phoneTab} label="Contacts" icon={<PersonPinIcon />} />
                </Tabs>
            </div>
        </div>
    );
});
