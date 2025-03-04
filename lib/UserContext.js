import { createContext, useContext, useState } from "react";

// Context 생성
const UserContext = createContext(null);

// Provider 설정
export const UserProvider = ({ children }) => {
  const [user, setUser] = useState(null);

  return (
    <UserContext.Provider value={{ user, setUser }}>
      {children}
    </UserContext.Provider>
  );
};

// Custom Hook
export const useUser = () => useContext(UserContext);
