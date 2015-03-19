json.title item.title
json.content item.content
json.children do
  json.partial! 'api/items/list', items: item.children
end
