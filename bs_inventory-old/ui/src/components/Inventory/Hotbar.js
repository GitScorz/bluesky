import Grid from '@material-ui/core/Grid';
import React, { Fragment, useState, useEffect } from 'react';
import { useSelector, connect } from 'react-redux';
import { makeStyles, Slide } from '@material-ui/core';
import Slot from './Slot';
import { useItem } from './actions';

const useStyles = makeStyles(theme => ({
    TheFuckingWrapperLikeInitMateYaKnowWhatImSayingYeaCauseImKoilYeahCosImACunt: {
        margin: '1% auto',
        color: '#000000',
        width: '85%',
        display: 'flex',
        flexWrap: 'wrap',
        flexBasis: 0,
    },
}));

export default connect()(props => {
    const classes = useStyles();
    const hidden = useSelector(state => state.app.showHotbar);
    const showing = useSelector(state => state.app.showing);
    const playerInventory = useSelector(state => state.inventory.player);

    useEffect(() => {
        let tmr = null;
        if (hidden) {
            tmr = setTimeout(() => {
                props.dispatch({
                    type: 'HOTBAR_HIDE',
                });
            }, 5000);
            
            return () => {
                clearTimeout(tmr);
            };
        }
    }, [hidden]);

    return (
        <Slide direction="down" in={hidden}>
            <div
                className={
                    classes.TheFuckingWrapperLikeInitMateYaKnowWhatImSayingYeaCauseImKoilYeahCosImACunt
                }
            >
                <Grid container justify={'center'} alignItems={'flex-start'}>
                    <Grid item xs={6}>
                        {[...Array(playerInventory.size).keys()].map(value => {
                            if (value + 1 <= 5) {
                                return (
                                    <Slot
                                        inHotbar={true}
                                        showing={showing}
                                        key={value + 1}
                                        slot={value + 1}
                                        owner={playerInventory.owner}
                                        invType={playerInventory.invType}
                                        hotkeys={true}
                                        onContextMenu={e =>
                                            onRightClick(
                                                e,
                                                playerInventory.owner,
                                                playerInventory.invType,
                                                playerInventory.inventory[
                                                    value + 1
                                                ]
                                                    ? playerInventory.inventory[
                                                        value + 1
                                                    ]
                                                    : {},
                                            )
                                        }
                                        data={
                                            playerInventory.inventory[value + 1]
                                                ? playerInventory.inventory[
                                                    value + 1
                                                ]
                                                : {}
                                        }
                                    />
                                );
                            }
                        })}
                    </Grid>
                </Grid>
            </div>
        </Slide>
    );
});
