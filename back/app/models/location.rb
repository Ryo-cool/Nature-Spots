class Location < ActiveHash::Base
  self.data = [
      {id: 1, name: '海'}, {id: 2, name: '山'}, {id: 3, name: '川'},
      {id: 4, name: '公園'}, {id: 5, name: '池'}, {id: 6, name: '湖'},
  ]
end