export const initialState = {
  hidden: true,
  state: 'CREATOR',
  loading: false,
  ped: {
    model: '',
    customization: {
      face: {
        face1: {
          index: 0,
          texture: 0,
          mix: 50.0,
        },
        face2: {
          index: 0,
          texture: 0,
          mix: 50.0,
        },
        features: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      },
      colors: {
        hair: {
          color1: {
            index: 0,
            rgb: 'rgb(0, 0, 0)',
          },
          color2: {
            index: 0,
            rgb: 'rgb(0, 0, 0)',
          },
        },
        facialhair: {
          color1: {
            index: 0,
            rgb: 'rgb(0, 0, 0)',
          },
          color2: {
            index: 0,
            rgb: 'rgb(0, 0, 0)',
          },
        },
        chesthair: {
          color1: {
            index: 0,
            rgb: 'rgb(0, 0, 0)',
          },
          color2: {
            index: 0,
            rgb: 'rgb(0, 0, 0)',
          },
        },
      },
      overlay: {
        blemish: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
        facialhair: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
        eyebrows: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
        ageing: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
        makeup: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
        blush: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
        complexion: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
        sundamage: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
        lipstick: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
        freckles: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
        chesthair: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
        bodyblemish: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
        addbodyblemish: {
          index: 0,
          opacity: 100.0,
          disabled: true,
        },
      },
      components: {
        face: {
          componentId: 0,
          drawableId: 0,
          textureId: 0,
        },
        mask: {
          componentId: 1,
          drawableId: 0,
          textureId: 0,
        },
        hair: {
          componentId: 2,
          drawableId: 0,
          textureId: 0,
        },
        torso: {
          componentId: 3,
          drawableId: 0,
          textureId: 0,
        },
        leg: {
          componentId: 4,
          drawableId: 0,
          textureId: 0,
        },
        bag: {
          componentId: 5,
          drawableId: 0,
          textureId: 0,
        },
        shoes: {
          componentId: 6,
          drawableId: 0,
          textureId: 0,
        },
        accessory: {
          componentId: 7,
          drawableId: 0,
          textureId: 0,
        },
        undershirt: {
          componentId: 8,
          drawableId: 0,
          textureId: 0,
        },
        kevlar: {
          componentId: 9,
          drawableId: 0,
          textureId: 0,
        },
        badge: {
          componentId: 10,
          drawableId: 0,
          textureId: 0,
        },
        torso2: {
          componentId: 11,
          drawableId: 0,
          textureId: 0,
        },
      },
      props: {
        hat: {
          componentId: 0,
          drawableId: 0,
          textureId: 0,
          disabled: true,
        },
        glass: {
          componentId: 1,
          drawableId: 0,
          textureId: 0,
          disabled: true,
        },
        ear: {
          componentId: 2,
          drawableId: 0,
          textureId: 0,
          disabled: true,
        },
        watch: {
          componentId: 6,
          drawableId: 0,
          textureId: 0,
          disabled: true,
        },
        bracelet: {
          componentId: 7,
          drawableId: 0,
          textureId: 0,
          disabled: true,
        },
      },
    },
  },
  drawables: {
    components: [],
    props: [],
  },
  textures: {
    components: [],
    props: [],
  },
  hairColors: 10,
};

const appReducer = (state = initialState, action) => {
  switch (action.type) {
    case 'APP_SHOW':
      return {
        ...state,
        hidden: false,
      };
    case 'APP_HIDE':
      return {
        ...state,
        hidden: true,
      };
    case 'SET_STATE':
      return {
        ...state,
        state: action.payload.state,
      };
    case 'SET_LOADING':
      return {
        ...state,
        loading: action.payload.loading,
      };
    case 'SET_PED_DATA':
      return {
        ...state,
        ped: action.payload.ped,
      };
    case 'UPDATE_PED_OVERLAY':
      return {
        ...state,
        ped: {
          ...state.ped,
          customization: {
            ...state.ped.customization,
            overlay: {
              ...state.ped.customization.overlay,
              [action.payload.type]: {
                ...state.ped.customization.overlay[action.payload.type],
                [action.payload.extraType]: action.payload.value,
              },
            },
          },
        },
      };
    case 'UPDATE_PED_FACE_FEATURE':
      const newFeatures = [...state.ped.customization.face.features];
      newFeatures[action.payload.index] = action.payload.value;
      return {
        ...state,
        ped: {
          ...state.ped,
          customization: {
            ...state.ped.customization,
            face: {
              ...state.ped.customization.face,
              features: newFeatures,
            },
          },
        },
      };
    case 'UPDATE_PED_FACE':
      return {
        ...state,
        ped: {
          ...state.ped,
          customization: {
            ...state.ped.customization,
            face: {
              ...state.ped.customization.face,
              [action.payload.face]: {
                ...state.ped.customization.face[action.payload.face],
                [action.payload.type]: action.payload.value,
              },
            },
          },
        },
      };
    case 'UPDATE_PED_COMPONENT_VARIATION': {
      return {
        ...state,
        ped: {
          ...state.ped,
          customization: {
            ...state.ped.customization,
            components: {
              ...state.ped.customization.components,
              [action.payload.name]: {
                ...state.ped.customization.components[action.payload.name],
                [action.payload.type]: action.payload.value,
              },
            },
          },
        },
      };
    }
    case 'UPDATE_PED_PROP': {
      return {
        ...state,
        ped: {
          ...state.ped,
          customization: {
            ...state.ped.customization,
            props: {
              ...state.ped.customization.props,
              [action.payload.name]: {
                ...state.ped.customization.props[action.payload.name],
                [action.payload.type]: action.payload.value,
              },
            },
          },
        },
      };
    }
    case 'UPDATE_PED_HAIR_COLOR': {
      return {
        ...state,
        ped: {
          ...state.ped,
          customization: {
            ...state.ped.customization,
            colors: {
              ...state.ped.customization.colors,
              [action.payload.name]: {
                ...state.ped.customization.colors[action.payload.name],
                [action.payload.type]: {
                  ...state.ped.customization.colors[action.payload.name][action.payload.type],
                  index: action.payload.value,
                },
              },
            },
          },
        },
      };
    }
    case 'UPDATE_PED_MODEL':
      return {
        ...state,
      };
    case 'SET_MAX_DRAWABLE':
      const newDrawables = [...state.drawables[action.payload.type]];
      newDrawables[action.payload.id] = action.payload.max;
      return {
        ...state,
        drawables: {
          ...state.drawables,
          [action.payload.type]: newDrawables,
        },
      };
    case 'SET_MAX_TEXTURE':
      const newTextures = [...state.textures[action.payload.type]];
      newTextures[action.payload.id] = action.payload.max;
      return {
        ...state,
        textures: {
          ...state.textures,
          [action.payload.type]: newTextures,
        },
      };
    case 'SET_HAIR_COLORS_MAX': {
      return {
        ...state,
        hairColors: action.payload.max,
      };
    }
    case 'SET_HAIR_COLOR_RGB': {
      return {
        ...state,
        ped: {
          ...state.ped,
          customization: {
            ...state.ped.customization,
            colors: {
              ...state.ped.customization.colors,
              [action.payload.name]: {
                ...state.ped.customization.colors[action.payload.name],
                [action.payload.type]: {
                  ...state.ped.customization.colors[action.payload.name][action.payload.type],
                  rgb: action.payload.rgb,
                },
              },
            },
          },
        },
      };
    }
    default:
      return state;
  }
};

export default appReducer;
