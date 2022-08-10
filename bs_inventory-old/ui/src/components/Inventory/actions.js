import Nui from '../../util/Nui';

const moveSlot = (ownerFrom, ownerTo, slotFrom, slotTo, invTypeFrom, invTypeTo, name, countFrom, countTo) => {
  Nui.send('MoveSlot', {
    ownerFrom: ownerFrom,
    ownerTo: ownerTo,
    slotFrom: slotFrom,
    slotTo: slotTo,
    name: name,
    countFrom: countFrom,
    countTo: countTo,
    invTypeFrom: invTypeFrom,
    invTypeTo: invTypeTo,
  });
};

const moveToNextSecondary = (ownerFrom, ownerTo, slotFrom, invTypeFrom, invTypeTo, name, count) => {
  Nui.send('NextSlotInSecondary', {
    ownerFrom: ownerFrom,
    ownerTo: ownerTo,
    slotFrom: slotFrom,
    name: name,
    invTypeFrom: invTypeFrom,
    invTypeTo: invTypeTo,
    Count: count
  });
};

const useItem = (ownerFrom, slotFrom, invTypeFrom) => {
  Nui.send('UseItem', {
    owner: ownerFrom,
    slot: slotFrom,
    invType: invTypeFrom,
  });
};

const dropItem = (ownerFrom, slotFrom, invTypeFrom, count) => {
  Nui.send('DropItem', {
    owner: ownerFrom,
    slot: slotFrom,
    invType: invTypeFrom,
    count: count
  });
};

const sendNotify = (alt, message, time) => {
  Nui.send('SendNotify', {
    alert: alt,
    message: message,
    time: time
  });
}

const closeInventory = () => {
  Nui.send('Close');
}

export { moveSlot, useItem, closeInventory, dropItem, moveToNextSecondary, sendNotify }