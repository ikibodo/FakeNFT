[Читать на русском](./README.ru.md)

# FakeNFT Mobile App — Technical Specification

## Links

- [Figma Design](https://www.figma.com/file/k1LcgXHGTHIeiCv4XuPbND/FakeNFT-(YP)?node-id=96-5542&t=YdNbOI8EcqdYmDeg-0)
- [Profile Screencast](https://youtube.com/shorts/fDB_H58HZeo?feature=shared)
- [Cart Screencast](https://youtube.com/shorts/QWTx-O4-NNM?feature=shared)
- [Statistics Screencast](https://youtube.com/shorts/pOBJhAXQD3U?feature=shared)

## Purpose and Goals

The application lets users browse and “purchase” NFTs (Non-Fungible Tokens).  
All purchase operations are simulated through a **mock backend**.

Key goals:

- Browse NFT collections  
- View and (simulated) purchase individual NFTs  
- View user ratings  

## App Overview

- The app showcases an NFT catalog structured into collections.  
- Users can view information about the catalog, a specific collection, and an individual NFT.  
- Favorite NFTs can be added to or removed from a favorites list.  
- NFTs can be added to / removed from the cart, and the order can be “paid for” (simulated).  
- Users can view the global leaderboard and detailed user profiles.  
- A profile section displays information about the current user, including owned and favorite NFTs.

**Optional (non-mandatory) features**

- Add localization support  
- Support dark theme  
- Integrate Yandex Metrica analytics  
- Authorization screen  
- Onboarding screen  
- Rate-the-app alert  
- Network-error banners  
- Custom launch screen  
- In-table or collection search within your feature module (Catalog, Cart, Profile, or Statistics)  

---

## Functional Requirements

### 1. Catalog

#### Catalog Screen

- A table (`UITableView`) lists available NFT collections, each showing  
  - Collection cover image  
  - Collection title  
  - NFT count  
- A sort button opens a list of sort options; the table is reordered accordingly.  
- While data is loading, a loading indicator is shown.  
- Selecting a collection opens its **Collection Screen**.

#### Collection Screen

Displays information about the selected NFT collection:

- Collection cover image  
- Collection title  
- Text description  
- Author name (link to author’s website)  
- A `UICollectionView` listing NFTs in the collection  

Tapping the author’s name opens the author’s website in an in-app web view.

Each NFT cell shows:

- NFT image  
- NFT title  
- NFT rating  
- Price (ETH)  
- Favorite / unfavorite button (heart)  
- Add-to-cart / remove-from-cart button  

Behavior:

- Tapping the heart toggles the NFT in Favorites.  
- Tapping the cart button adds/removes the NFT from the order; the icon switches between “plus” and “cross”.  
- Tapping a cell can open an **NFT Details Screen** (optional feature).

---

### 2. Cart

#### Cart (Order) Screen

- A table lists NFTs added to the order, each showing  
  - Image  
  - Name  
  - Rating  
  - Price (ETH)  
  - Remove-from-cart button  

Removing an NFT:

- Tapping the remove button opens a confirmation sheet displaying  
  - NFT image  
  - Deletion text  
  - Confirm button  
  - Cancel button  

Additional UI:

- A sort button at the top reorders items by the selected sort mode.  
- A bottom panel shows item count, total price, and a **Pay** button. Tapping **Pay** opens the **Currency Selection Screen**.  
- While data is loading or refreshing, a loading indicator is shown.

#### Currency Selection Screen

- Header with back button.  
- A `UICollectionView` lists available payment currencies, each with  
  - Logo  
  - Full name  
  - Ticker symbol  
- A link to the User Agreement (<https://yandex.ru/legal/practicum_termsofuse/>) opens in a web view.  
- A **Pay** button sends a request to the server.  
  - On success: success screen with a button back to the cart.  
  - On failure: popup with Retry and Cancel buttons.

---

### 3. Profile

#### Profile Screen

Shows user information:

- User avatar  
- Username  
- User description  
- Table (`UITableView`) with cells:  
  - **My NFTs** → opens the user’s NFTs  
  - **Favorites** → opens favorite NFTs  
  - **User Website** → opens in web view  

An **Edit** button (top-right) opens a sheet where the user can edit name, description, website, and avatar URL (only the URL is updated; the image itself is not uploaded).

#### My NFTs Screen

`UITableView`; each cell displays:

- NFT icon  
- NFT title  
- NFT author  
- Price (ETH)  

A sort button lets the user choose a sort mode; the table reorders accordingly.  
If no NFTs are present, an empty-state message is shown.

#### Favorites Screen

`UICollectionView` of favorited NFTs; each cell shows:

- NFT icon  
- Heart button  
- NFT title  
- NFT rating  
- Price (ETH)  

Tapping the heart removes the NFT from Favorites and refreshes the collection.  
If no favorites exist, an empty-state message is shown.

---

### 4. Statistics

#### Leaderboard Screen

A table of users, each row showing:

- Rank position  
- Avatar  
- Username  
- NFT count  

A sort button lets the user choose a sort mode; the table reorders accordingly.  
Selecting a row opens the **User Details Screen**.

#### User Details Screen

Displays:

- User avatar  
- Username  
- User description  

Includes a button to the user’s website (web view) and a link to the **User Collection Screen**.

#### User Collection Screen

`UICollectionView` of the user’s NFTs; each cell shows:

- NFT icon  
- Heart button  
- NFT title  
- NFT rating  
- Price (ETH)  
- Add-to-cart / remove-from-cart button  

---

## Data Sorting

Screens **Catalog**, **Cart**, **My NFTs**, and **Statistics** support user-selectable sorting.  
The chosen sort order must be stored locally and restored on app launch.

Default sort mode:

- **Catalog** — by NFT count  
- **Cart** — by name  
- **My NFTs** — by rating  
- **Statistics** — by rating
