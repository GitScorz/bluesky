import Grid from '@material-ui/core/Grid';
import React, { Fragment, useState, useEffect } from 'react';
import { useSelector, connect } from 'react-redux';
import { makeStyles, Fade, Menu, MenuItem } from '@material-ui/core';
import Slot from './Slot';
import { useItem } from './actions';

import Split from './Split';

const useStyles = makeStyles((theme) => ({
  root: {
    width: 1615,
    position: 'absolute',
    left: 0,
    right: 0,
    margin: 'auto',
    marginTop: -40,
    userSelect: 'none',
    '-webkit-user-select': 'none',
  },
  inventoryGrid: {
    maxHeight: '60vh',
    overflowX: 'hidden',
    overflowY: 'auto',
    display: 'flex',
    flexWrap: 'wrap',
    flexBasis: 0,
    marginTop: 25,
    padding: '0 25px',
    userSelect: 'none',
    '-webkit-user-select': 'none',
  },
  inventoryLeftHeader: {
    paddingLeft: 30,
    fontWeight: 'bold',
    marginTop: 10,
    fontSize: 18,
    userSelect: 'none',
    '-webkit-user-select': 'none',
  },
  inventoryLeftSubHeader: {
    paddingLeft: 33,
    fontSize: 13,
    marginBottom: 5,
    userSelect: 'none',
    '-webkit-user-select': 'none',
  },
  inventoryRightHeader: {
    width: '100%',
    textAlign: 'right',
    paddingRight: 40,
    marginTop: 10,
    fontWeight: 'bold',
    fontSize: 18,
    userSelect: 'none',
    '-webkit-user-select': 'none',
  },
  inventoryRightSubHeader: {
    width: '100%',
    textAlign: 'right',
    paddingRight: 43,
    fontSize: 13,
    height: 17,
    marginBottom: 5,
    userSelect: 'none',
    '-webkit-user-select': 'none',
  },
  slot: {
    width: '100%',
    height: '120px',
    backgroundColor: theme.palette.secondary.dark,
    border: `1px solid ${theme.palette.secondary.light}`,
    position: 'relative',
    userSelect: 'none',
    '-webkit-user-select': 'none',
  },
  count: {
    bottom: theme.spacing(1),
    right: theme.spacing(2),
    width: '10%',
    height: '10%',
    position: 'absolute',
    userSelect: 'none',
    '-webkit-user-select': 'none',
  },
}));

export default connect()((props) => {
  const classes = useStyles();

  const playerInventory = useSelector((state) => state.inventory.player);
  const secondaryInventory = useSelector((state) => state.inventory.secondary);
  const showSecondary = useSelector((state) => state.inventory.showSecondary);
  const contextData = useSelector((state) => state.inventory.contextItem);
  const showSplit = useSelector((state) => state.inventory.splitItem);
  const hoverOrigin = useSelector(state => state.inventory.hoverOrigin);
  /*const items = useSelector((state) => state.inventory.items);*/

  useEffect(() => {
    return () => {
      closeContext();      
      closeSplitContext();
    }
  }, []);

	const [offset, setOffset] = useState({
		left: 110,
		top: 0,
  });

	const onRightClick = (e, owner, invType, item) => {
    e.preventDefault();
    if(hoverOrigin != null) return;
    setOffset({ left: e.clientX - 2, top: e.clientY - 4 });

    if (item.Name != null) {
      if (e.ctrlKey) {
        props.dispatch({ type: 'SET_SPLIT_ITEM', payload: { owner, item, invType } })
      } else if(e.shiftKey) {
        props.dispatch({
          type: 'SET_HOVER',
          payload: {
            Name: item.Name,
            Image: item.Image,
            Label: item.Label,
            Count: (item.Count > 1 ? Math.floor(item.Count / 2) : 1)
          },
        });
        props.dispatch({
          type: 'SET_HOVER_ORIGIN',
          payload: {
              slot: item.Slot,
              owner: owner,
              invType: invType,
              ...item,
          }
        });

        closeContext();
        closeSplitContext();
      } else {
        props.dispatch({ type: 'SET_CONTEXT_ITEM', payload: { owner, item, invType } });
      }
    }
  };
  
  const cancelDrag = e => {
    props.dispatch({
        type: 'SET_HOVER',
        payload: null,
    });
    props.dispatch({
        type: 'SET_HOVER_ORIGIN',
        payload: null,
    });
  }
	
	const closeContext = e => {
		if (e != null) e.preventDefault();
    props.dispatch({
      type: 'SET_CONTEXT_ITEM',
      payload: null
    });
	};
	
	const closeSplitContext = e => {
		if (e != null) e.preventDefault();
    props.dispatch({
      type: 'SET_SPLIT_ITEM',
      payload: null
    });
	};
  
  const proCoderUsesItem = (e) => {
    if(contextData == null || contextData.invType != 1) return;
    useItem(contextData.owner, contextData.item.Slot, contextData.invType);
    closeContext();
    closeSplitContext();
  };

  const split = e => {
    props.dispatch({
      type: 'SET_SPLIT_ITEM',
      payload: contextData
    });
    closeContext();
  };

  return (
    <Fragment>
      <Grid
        container
        justify={'flex-start'}
        alignItems={'flex-start'}
        className={classes.root}
        onClick={cancelDrag}
      >
        <Grid item xs={6} onClick={cancelDrag}>
          <div className={classes.inventoryLeftHeader}>{playerInventory.name}</div>
          <div className={classes.inventoryLeftSubHeader}>Personal Storage</div>
          <div className={classes.inventoryGrid}>
            {[...Array(playerInventory.size).keys()].map((value) => {
              return (
                <Slot
                  key={value + 1}
                  slot={value + 1}
                  owner={playerInventory.owner}
                  invType={playerInventory.invType}
                  hotkeys={true}
                  onContextMenu={e => onRightClick(e, playerInventory.owner, playerInventory.invType, playerInventory.inventory[value + 1] ? playerInventory.inventory[value + 1] : {})}
                  data={
                    playerInventory.inventory[value + 1]
                      ? playerInventory.inventory[value + 1]
                      : {}
                  }
                />
              );
            })}
          </div>
        </Grid>
        <Fade in={showSecondary}>
          <Grid item xs={6}>
            <div className={classes.inventoryRightHeader}>{secondaryInventory.name}</div>
            <div className={classes.inventoryRightSubHeader}></div>
            <Grid
              container
              className={classes.inventoryGrid}
              justify={'flex-start'}
              alignItems={'flex-start'}
            >
              {[...Array(secondaryInventory.size).keys()].map((value) => {
                return (
                  <Slot
                    slot={value + 1}
                    key={value + 1}
                    owner={secondaryInventory.owner}
                    invType ={secondaryInventory.invType}
                    hotkeys={false}
                    onContextMenu={e => onRightClick(e, secondaryInventory.owner, secondaryInventory.invType, secondaryInventory.inventory[value + 1] ? secondaryInventory.inventory[value + 1] : {})}
                    data={
                      secondaryInventory.inventory[value + 1]
                        ? secondaryInventory.inventory[value + 1]
                        : {}
                    }
                  />
                );
              })}
            </Grid>
          </Grid>
        </Fade>
      </Grid>

			{contextData != null ? (
				<Menu
					keepMounted
					onClose={closeContext}
					onContextMenu={closeContext}
					open={!!contextData}
					anchorReference="anchorPosition"
					anchorPosition={offset}
          TransitionComponent={Fade}
				>
					<MenuItem disabled>{contextData.item.Label}</MenuItem>
          {playerInventory.owner == contextData.owner ? 
            <MenuItem onClick={proCoderUsesItem}>Use {contextData.item.Label}</MenuItem> : null
          }
          {playerInventory.owner == contextData.owner ? 
            <MenuItem onClick={proCoderUsesItem}>Give {contextData.item.Label}</MenuItem> : null
          }
            <MenuItem onClick={split}>Manage Item</MenuItem>
				</Menu>
			) : null}


      {
        showSplit != null ?
        <Menu
					keepMounted
					onClose={closeSplitContext}
					onContextMenu={closeSplitContext}
					open={!!showSplit}
					anchorReference="anchorPosition"
					anchorPosition={offset}
          TransitionComponent={Fade}
				>
          <MenuItem disabled>Split Stack</MenuItem>
          <Split data={showSplit}/>
				</Menu> : null
      }
    </Fragment>
  );
});